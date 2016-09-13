//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Lucas Domene Firmo on 9/12/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    @IBOutlet var imageView: UIImageView!
    
    // MARK: - Attributes
    
    var store: PhotoStore!
    
    // MARK: - View's Life Cycle
    
    override func viewDidLoad() {
        store.fetchRecentPhotos { photosResult in
            switch photosResult {
            case let .Success(photos):
                print("Successfully found \(photos.count) recent photos.")
            case let .Failure(error):
                print("Error fetching recent photos: \(error)")
            }
        }
    }
}
