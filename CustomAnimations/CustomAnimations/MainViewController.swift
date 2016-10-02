//
//  MainViewController.swift
//  CustomAnimations
//
//  Created by Lucas Domene Firmo on 10/2/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

class MainViewController: UICollectionViewController {

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "Cell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        UIView.animateWithDuration(0.25, delay:0, options: .CurveEaseOut, animations: {
            cell?.transform = CGAffineTransformMakeScale(0.7, 0.7)
            cell?.layer.cornerRadius = 30.0
        }) { bool in
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            cell?.transform = CGAffineTransformIdentity
            cell?.layer.cornerRadius = 15.0
            }, completion:  nil)
        }
        
    }
}
