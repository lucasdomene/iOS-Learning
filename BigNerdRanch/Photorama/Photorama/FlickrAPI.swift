//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Lucas Domene Firmo on 9/12/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import Foundation

enum Method: String {
    case RecentPhotos = "flickr.photos.getRecent"
}

struct Flickr {
    
    // MARK: - Attributes
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "a6d819499131071f158fd740860a5a88"
    
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
}
