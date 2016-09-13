//
//  ItemCell.swift
//  Homepwner
//
//  Created by Lucas Domene Firmo on 9/7/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    // MARK: - @IBOutlets
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    // MARK: - Instance Methods
    
    func updateLabels() {
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        nameLabel.font = bodyFont
        valueLabel.font = bodyFont
        
        let caption1Font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        serialNumberLabel.font = caption1Font
    }
}
