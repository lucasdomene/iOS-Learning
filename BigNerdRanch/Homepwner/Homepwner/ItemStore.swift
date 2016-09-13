//
//  ItemStore.swift
//  Homepwner
//
//  Created by Lucas Domene Firmo on 9/6/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

class ItemStore {
    
    // MARK: - Attributes
    
    var allItems = [Item]()
    let itemArchiveURL: NSURL = {
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectory.first!
        return documentDirectory.URLByAppendingPathComponent("items.archive")
    }()
    
    // MARK: - Init
    
    init() {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchiveURL.path!) as? [Item] {
            allItems = archivedItems
        }
    }
    
    // MARK: - Instance Methods
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem
    }
    
    func removeItem(item: Item) {
        if let index = allItems.indexOf(item) {
            allItems.removeAtIndex(index)
        }
    }
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex ==  toIndex {
            return
        }
        
        let movedItem = allItems[fromIndex]
        allItems.removeAtIndex(fromIndex)
        allItems.insert(movedItem, atIndex: toIndex)
    }
    
    func saveChanges() -> Bool {
        print("Saving items to: \(itemArchiveURL.path!)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path!)
    }
}
