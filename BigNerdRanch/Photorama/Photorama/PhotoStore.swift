//
//  PhotoStore.swift
//  Photorama
//
//  Created by Lucas Domene Firmo on 9/12/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit
import CoreData

enum ImageResult {
    case Success(UIImage)
    case Failure(ErrorType)
}

enum PhotoError: ErrorType {
    case ImageCreationError
}

class PhotoStore {
    
    // MARK: - Attributes
    
    let coreDataStack = CoreDataStack(modelName: "Photorama")
    let imageStore = ImageStore()
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()

    // MARK: - Data Fetchers
    
    func fetchRecentPhotos(completion completion: (PhotoResult) -> Void) {
        let url = FlickrAPI.recentPhotosURL()
        let request = NSURLRequest(URL: url)
        session.dataTaskWithRequest(request) { (data, response, error) in
            var result = self.processRecentPhotosRequest(data: data, error: error)
            
            if case let .Success(photos) = result {
                let privateQueueContext = self.coreDataStack.privateQueueContext
                privateQueueContext.performBlockAndWait({
                    try! privateQueueContext.obtainPermanentIDsForObjects(photos)
                })
                let objectIDs = photos.map{ $0.objectID }
                let predicate = NSPredicate(format: "self IN %@", objectIDs)
                let sortByDateTaken = NSSortDescriptor(key: "dateTaken", ascending: true)
                
                do {
                    try self.coreDataStack.saveChanges()
                    let mainQueuePhotos = try self.fetchMainQueuePhotos(predicate: predicate, sortDescriptors: [sortByDateTaken])
                    result = .Success(mainQueuePhotos)
                } catch let error {
                    result = .Failure(error)
                }
            }
            
            completion(result)
        }.resume()
    }
    
    func fetchImageForPhoto(photo: Photo, completion: (ImageResult) -> Void) {
        let photoKey = photo.photoKey
        if let image = imageStore.imageForKey(photoKey) {
            photo.image = image
            completion(.Success(image))
            return
        }
        
        let photoURL = photo.remoteURL
        let request = NSURLRequest(URL: photoURL)
        session.dataTaskWithRequest(request) { (data, response, error) in
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .Success(image) = result {
                photo.image = image
                self.imageStore.setImage(image, forkey: photoKey)
            }
            completion(result)
        }.resume()
    }
    
    func fetchMainQueuePhotos(predicate predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Photo] {
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        var mainQueuePhotos: [Photo]?
        var fetchRequestError: ErrorType?
        
        mainQueueContext.performBlockAndWait { 
            do {
                mainQueuePhotos = try mainQueueContext.executeFetchRequest(fetchRequest) as? [Photo]
            } catch let error {
                fetchRequestError = error
            }
        }
        
        guard let photos = mainQueuePhotos else {
            throw fetchRequestError!
        }
        
        return photos
    }
    
    func fetchMainQueueTags(predicate predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: "Tag")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        var mainQueueTags: [NSManagedObject]?
        var fetchRequestError: ErrorType?
        
        mainQueueContext.performBlockAndWait {
            do {
                mainQueueTags = try mainQueueContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            } catch let error {
                fetchRequestError = error
            }
        }
        
        guard let tags = mainQueueTags else {
            throw fetchRequestError!
        }
        
        return tags
    }
    
    // MARK: - Data Processors
    
    func processRecentPhotosRequest(data data: NSData?, error: NSError?) -> PhotoResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        
        return FlickrAPI.photosFromJSONData(jsonData, inContext: self.coreDataStack.privateQueueContext)
    }
    
    func processImageRequest(data data: NSData?, error: NSError?) -> ImageResult {
        guard let imageData = data, image = UIImage(data: imageData) else {
            if data == nil {
                return .Failure(error!)
            } else {
                return .Failure(PhotoError.ImageCreationError)
            }
        }
        
        return .Success(image)
    }
}
