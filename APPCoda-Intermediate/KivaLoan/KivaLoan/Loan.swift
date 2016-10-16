//
//  Loan.swift
//  KivaLoan
//
//  Created by Lucas Domene Firmo on 10/16/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation

class Loan {
    
    var name: String
    var country: String
    var use: String
    var amount: Int
    
    init(name: String, country: String, use: String, amount: Int) {
        self.name = name
        self.country = country
        self.use = use
        self.amount = amount
    }
    
}
