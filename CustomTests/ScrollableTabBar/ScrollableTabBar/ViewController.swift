//
//  ViewController.swift
//  ScrollableTabBar
//
//  Created by Lucas Domene Firmo on 10/1/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var customBar: UIView!
    @IBOutlet var settingsBarItem: UIButton!
    @IBOutlet var homeBarItem: UIButton!
    @IBOutlet var promotionsBarItem: UIButton!
    
    var selectionViewWidthConstraint: NSLayoutConstraint!
    var selectionViewCenterConstraint: NSLayoutConstraint!
    var selectionView: UIView!
    
    var selectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectionView = UIView()
        selectionView.backgroundColor = UIColor.greenColor()
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        customBar.addSubview(selectionView)
        
        selectionView.heightAnchor.constraintEqualToConstant(5).active = true
        selectionView.bottomAnchor.constraintEqualToAnchor(customBar.bottomAnchor, constant: 0.0).active = true
        addNewSelectionViewContraintsRelatedToButton(homeBarItem)
        
        changeButtonColor(homeBarItem.tag)
        selectedIndex = homeBarItem.tag
    }

    @IBAction func customBarItemPressed(sender: UIButton) {
        print("Selected Button Tag: \(sender.tag)")
        switch sender.tag {
        case 1:
            addNewSelectionViewContraintsRelatedToButton(settingsBarItem)
            changeButtonColor(settingsBarItem.tag)
            selectedIndex = settingsBarItem.tag
        case 2:
            addNewSelectionViewContraintsRelatedToButton(homeBarItem)
            changeButtonColor(homeBarItem.tag)
            selectedIndex = homeBarItem.tag
        case 3:
            addNewSelectionViewContraintsRelatedToButton(promotionsBarItem)
            changeButtonColor(promotionsBarItem.tag)
            selectedIndex = promotionsBarItem.tag
        default:
            break;
        }
    }
    
    func addNewSelectionViewContraintsRelatedToButton(button: UIButton) {
        if selectionViewWidthConstraint != nil && selectionViewCenterConstraint != nil {
            customBar.removeConstraint(selectionViewCenterConstraint)
            customBar.removeConstraint(selectionViewWidthConstraint)
        }
    
        selectionViewCenterConstraint = selectionView.widthAnchor.constraintEqualToAnchor(button.widthAnchor, constant: 0.0)
        selectionViewWidthConstraint = selectionView.centerXAnchor.constraintEqualToAnchor(button.centerXAnchor, constant: 0.0)
        selectionViewWidthConstraint.active = true
        selectionViewCenterConstraint.active = true
    }
    
    func changeButtonColor(index: Int) {
        if index == selectedIndex {
            return
        }
        
        if selectedIndex != nil {
            let previousSelectedButton = customBar.viewWithTag(selectedIndex!) as? UIButton
            previousSelectedButton?.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
        
        let selectedButton = customBar.viewWithTag(index) as? UIButton
        selectedButton?.setTitleColor(UIColor.greenColor(), forState: .Normal)
    }
    
}

