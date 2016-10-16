//
//  AttachmentTableViewController.swift
//  EmailAttachment
//
//  Created by Simon Ng on 21/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import UIKit
import MessageUI

class AttachmentTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    enum MIMEType: String {
        case jpg = "image/jpeg"
        case png = "image/png"
        case doc = "application/msword"
        case ppt = "application/vnd.ms-powerpoint"
        case html = "text/html"
        case pdf = "application/pdf"
        
        init?(type: String) {
            switch type.lowercased() {
                case "jpg": self = .jpg
                case "png": self = .png
                case "doc": self = .doc
                case "ppt": self = .ppt
                case "html": self = .html
                case "pdf": self = .pdf
                default: return nil
            }
        }
    }
    
    let filenames = ["10 Great iPhone Tips.pdf", "camera-photo-tips.html", "foggy.jpg", "Hello World.ppt", "no more complaint.png", "Why Appcoda.doc"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filenames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 

        cell.textLabel?.text = filenames[(indexPath as NSIndexPath).row]
        cell.imageView?.image = UIImage(named: "icon\((indexPath as NSIndexPath).row).png");

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = filenames[indexPath.row]
        showEmail(attachmentFile: selectedFile)
    }
    
    // Mail
    
    func showEmail(attachmentFile: String) {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        let emailTitle = "Great Photo and Doc"
        let messageBody = "Hey, check this out!"
        let toRecipients = ["support@appcode.com"]
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        mailComposer.setToRecipients(toRecipients)
        
        let fileParts = attachmentFile.components(separatedBy: ".")
        let fileName = fileParts[0]
        let fileExtension = fileParts[1]
        
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: fileExtension) else {
            return
        }
        
        if let fileData = NSData(contentsOfFile: filePath), let mimeType = MIMEType(type: fileExtension) {
            mailComposer.addAttachmentData(fileData as Data, mimeType: mimeType.rawValue, fileName: fileName)
            
            present(mailComposer, animated: true, completion: nil)
        }
    }
    
    // MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail failed")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
