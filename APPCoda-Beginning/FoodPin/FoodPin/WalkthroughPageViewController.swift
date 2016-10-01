//
//  WalkthroughPageViewController.swift
//  FoodPin
//
//  Created by Lucas Domene Firmo on 10/1/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pageHeadings = ["Personalize", "Locate", "Discover"]
    var pageImages = ["foodpin-intro-1", "foodpin-intro-2", "foodpin-intro-3"]
    var pageContent = ["Pin your favorite restaurants and create your own food guide","Search and locate your favourite restaurant on Maps","Find restaurants pinned by your friends and other foodies around the world"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let startingViewController = viewControllerAtIndex(0) {
            setViewControllers([startingViewController], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> WalkthroughContentViewController? {
        if index == NSNotFound || index < 0 || index >= pageHeadings.count {
            return nil
        }
        
        if let pageContentViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthroughContentViewController") as? WalkthroughContentViewController {
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.content = pageContent[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
    }
}