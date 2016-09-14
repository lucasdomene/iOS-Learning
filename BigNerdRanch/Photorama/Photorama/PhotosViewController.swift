//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Lucas Domene Firmo on 9/12/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: - @IBOutlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Attributes
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    // MARK: - View's Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        store.fetchRecentPhotos { photosResult in
            let sortByDateTaken = NSSortDescriptor(key: "dateTaken", ascending: true)
            let allPhotos = try! self.store.fetchMainQueuePhotos(predicate: nil, sortDescriptors: [sortByDateTaken])
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.photoDataSource.photos = allPhotos
                self.collectionView.reloadSections(NSIndexSet(index: 0))
            }
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        store.fetchImageForPhoto(photo) { imageResult in
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                let photoIndex = self.photoDataSource.photos.indexOf(photo)!
                let photoIndexPath = NSIndexPath(forRow: photoIndex, inSection: 0)
                
                if let cell = self.collectionView.cellForItemAtIndexPath(photoIndexPath) as? PhotoCollectionViewCell {
                    cell.updateWithImage(photo.image)
                }
            })
        }
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhoto" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                let destinationViewController = segue.destinationViewController as! PhotoInfoViewController
                destinationViewController.photo = photo
                destinationViewController.store = store
            }
        }
    }
}
