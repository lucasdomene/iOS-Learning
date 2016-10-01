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
    
    var selectedIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectionView = UIView()
        selectionView.backgroundColor = UIColor.greenColor()
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        customBar.addSubview(selectionView)
        
        selectionView.heightAnchor.constraintEqualToConstant(5).active = true
        selectionView.bottomAnchor.constraintEqualToAnchor(customBar.bottomAnchor, constant: 0.0).active = true
        addNewSelectionViewContraintsRelatedToButton(homeBarItem)
        
        selectedIndex = 1
        changeButtonColor(selectedIndex)
    }

    @IBAction func customBarItemPressed(sender: UIButton) {
        print("Selected Button Tag: \(sender.tag)")
        switch sender.tag {
        case 0:
            addNewSelectionViewContraintsRelatedToButton(settingsBarItem)
        case 1:
            addNewSelectionViewContraintsRelatedToButton(homeBarItem)
            break;
        case 2:
            addNewSelectionViewContraintsRelatedToButton(promotionsBarItem)
            break;
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
        
    }
    
}

