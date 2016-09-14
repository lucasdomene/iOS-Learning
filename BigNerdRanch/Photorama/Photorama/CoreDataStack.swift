//
//  CoreDataStack.swift
//  Photorama
//
//  Created by Lucas Domene Firmo on 9/13/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // MARK: - Attributes
    
    let managedObjectModelName: String
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(self.managedObjectModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    private var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls.first!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        var coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let pathComponent = "\(self.managedObjectModelName).sqlite"
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(pathComponent)
        let store = try! coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        return coordinator
    }()
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        moc.name = "Main Queue Context (UI Context)"
        return moc
    }()
    
    lazy var privateQueueContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        moc.parentContext = self.mainQueueContext
        moc.name = "Primary Private Queue Context"
        return moc
    }()
    
    // MARK: - Init
    
    required init(modelName: String) {
        managedObjectModelName = modelName
    }
    
    // MARK: - Instance Methods
    
    func saveChanges() throws {
        var error: ErrorType?
        
        privateQueueContext.performBlockAndWait { 
            if self.privateQueueContext.hasChanges {
                do {
                    try self.privateQueueContext.save()
                } catch let saveError {
                    error = saveError
                }
            }
        }
        
        if let error = error {
            throw error
        }
        
        mainQueueContext.performBlockAndWait { 
            if self.mainQueueContext.hasChanges {
                do {
                    try self.mainQueueContext.save()
                } catch let saveError {
                    error = saveError
                }
            }
        }
        
        if let error = error {
            throw error
        }
    }
    
}
