//
//  ImageStore.swift
//  Homepwner
//
//  Created by Lucas Domene Firmo on 9/7/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

class ImageStore: NSObject {
    
    let cache = NSCache()
    
    func setImage(image: UIImage, forkey key: String) {
        cache.setObject(image, forKey: key)
    }
    
    func imageForKey(key: String) -> UIImage? {
        return cache.objectForKey(key) as? UIImage
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObjectForKey(key)
    }
}
