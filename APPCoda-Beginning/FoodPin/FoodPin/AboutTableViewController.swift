//
//  AboutTableViewController.swift
//  FoodPin
//
//  Created by Lucas Domene Firmo on 10/1/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    
    var sectionTitles = ["Leave Feedback", "Follow Us"]
    var sectionContent = [["Rate us on App Store", "Tell us your feedback"],["Twitter", "Facebook", "Pinterest"]]
    var links = ["https://twitter.com/appcodamobile","https://facebook.com/appcodamobile", "https://www.pinterest.com/appcoda/"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame:CGRectZero)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionContent.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContent[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                if let url = NSURL(string: "http://www.apple.com/itunes/charts/paid-apps/") {
                    UIApplication.sharedApplication().openURL(url)
                }
            } else if indexPath.row == 1 {
                performSegueWithIdentifier("showWebView", sender: self)
            }
        case 1:
            if let url = NSURL(string: links[indexPath.row]) {
                let safariController = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
                presentViewController(safariController, animated: true, completion: nil)
            }
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
