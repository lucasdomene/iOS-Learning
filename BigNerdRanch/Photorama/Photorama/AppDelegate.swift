//
//  AppDelegate.swift
//  Photorama
//
//  Created by Lucas Domene Firmo on 9/12/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let rootViewController = window!.rootViewController as! UINavigationController
        let photosViewController = rootViewController.topViewController as! PhotosViewController
        photosViewController.store = PhotoStore()
        return true
    }
}

