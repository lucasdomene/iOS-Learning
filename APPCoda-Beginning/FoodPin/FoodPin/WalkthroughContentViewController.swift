//
//  WalkthroughContentViewController.swift
//  FoodPin
//
//  Created by Lucas Domene Firmo on 10/1/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var contentImageView: UIImageView!
    @IBOutlet var doneButton: UIButton!
    
    var index = 0
    var heading = ""
    var imageFile = ""
    var content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headingLabel.text = heading
        contentLabel.text = content
        contentImageView.image = UIImage(named: imageFile)
        
        if index == 2 {
            doneButton.hidden = false
        } else {
            doneButton.hidden = true
        }
    }
    
    @IBAction func doneButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
