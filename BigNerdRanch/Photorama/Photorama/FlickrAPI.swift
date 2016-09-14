//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Lucas Domene Firmo on 9/12/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import Foundation
import CoreData

enum Method: String {
    case RecentPhotos = "flickr.photos.getRecent"
}

enum PhotoResult {
    case Success([Photo])
    case Failure(ErrorType)
}

enum FlickrError: ErrorType {
    case InvalidJSONData
}

struct FlickrAPI {
    
    // MARK: - Attributes
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "a6d819499131071f158fd740860a5a88"
    
    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    // MARK: - Static Functions
    
    private static func flickrURL(method: Method, parameters: [String: String]?) -> NSURL {
        let components = NSURLComponents(string: baseURLString)!
        
        var queryItems = [NSURLQueryItem]()
        
        let baseParameters = ["method": method.rawValue, "format": "json", "nojsoncallback": "1", "api_key": APIKey]
        
        for (key, value) in baseParameters {
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParameters = parameters {
            for (key, value) in additionalParameters {
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        return components.URL!
    }
    
    static func recentPhotosURL() -> NSURL {
        return flickrURL(.RecentPhotos, parameters: ["extras": "url_h,date_taken"])
    }
    
    static func photosFromJSONData(data: NSData, inContext context: NSManagedObjectContext) -> PhotoResult {
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            guard let jsonDictionary = jsonObject as? [NSObject: AnyObject],
                      photos = jsonDictionary["photos"] as? [String: AnyObject],
                      photosArray = photos["photo"] as? [[String: AnyObject]] else {
                return .Failure(FlickrError.InvalidJSONData)
            }
            
            var finalPhotos = [Photo]()
            
            for photoJSON in photosArray {
                if let photo = photoFromJSONObject(photoJSON, inContext: context) {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.count == 0 && photosArray.count > 0 {
                return .Failure(FlickrError.InvalidJSONData)
            }
            
            return .Success(finalPhotos)
        } catch let error {
            return .Failure(error)
        }
    }
    
    private static func photoFromJSONObject(json: [String: AnyObject], inContext context: NSManagedObjectContext) -> Photo? {
        guard let photoID = json["id"] as? String,
                title = json["title"] as? String,
                dateString = json["datetaken"] as? String,
                photoURLString = json["url_h"] as? String,
                url = NSURL(string: photoURLString),
                dateTaken = dateFormatter.dateFromString(dateString) else {
            return nil
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        let predicate = NSPredicate(format: "photoID == \(photoID)")
        fetchRequest.predicate = predicate
        var fetchedPhotos: [Photo]!
        
        context.performBlockAndWait { 
            fetchedPhotos = try! context.executeFetchRequest(fetchRequest) as! [Photo]
        }
        
        if fetchedPhotos.count > 0 {
            return fetchedPhotos.first
        }
        
        var photo: Photo!
        context.performBlockAndWait { 
            photo = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: context) as! Photo
            photo.title = title
            photo.photoID = photoID
            photo.remoteURL = url
            photo.dateTaken = dateTaken
        }
        return photo
    }
}
