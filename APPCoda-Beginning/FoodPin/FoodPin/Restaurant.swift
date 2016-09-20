//
//  Restaurant.swift
//  FoodPin
//
//  Created by Simon Ng on 20/8/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import Foundation
import CoreData

class Restaurant: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var type: String
    @NSManaged var location: String
    @NSManaged var phoneNumber: String?
    @NSManaged var image: NSData?
    @NSManaged var isVisited: NSNumber?
    @NSManaged var rating: String?
}

