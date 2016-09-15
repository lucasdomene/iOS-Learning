//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Lucas Domene Firmo on 9/15/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var ratingStackView: UIStackView!
    
    var rating: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 500)
        ratingStackView.transform = CGAffineTransformConcat(scale, translate)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            self.ratingStackView.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    @IBAction func ratingSelected(sender: UIButton) {
        switch sender.tag {
        case 100:
            rating = "dislike"
        case 200:
            rating = "good"
        case 300:
            rating = "great"
        default:
            break
        }
        
        performSegueWithIdentifier("unwindToDetailView", sender: sender)
    }
}
