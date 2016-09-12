//
//  AppDelegate.swift
//  Homepwner
//
//  Created by Lucas Domene Firmo on 9/6/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let itemStore = ItemStore()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let imageStore = ImageStore()
        
        let navController = window!.rootViewController as! UINavigationController
        let itemsController = navController.topViewController as! ItemsViewController
        
        itemsController.itemStore = itemStore
        itemsController.imageStore = imageStore
        
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        let success = itemStore.saveChanges()
        if success {
            print("Saved all of the Items")
        } else {
            print("Could not save any of the Items")
        }
    }

}

