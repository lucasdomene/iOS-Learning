//
//  WebViewController.swift
//  FoodPin
//
//  Created by Lucas Domene Firmo on 10/1/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = NSURL(string: "http://www.appcoda.com/contact") {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }
    
}
