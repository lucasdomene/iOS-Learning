//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Simon Ng on 11/8/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import UIKit
import Social

class RestaurantTableViewController: UITableViewController {
    var restaurantNames = ["Cafe Deadend", "Homei", "Teakha", "Cafe Loisl", "Petite Oyster", "For Kee Restaurant", "Po's Atelier", "Bourke Street Bakery", "Haigh's Chocolate", "Palomino Espresso", "Upstate", "Traif", "Graham Avenue Meats", "Waffle & Wolf", "Five Leaves", "Cafe Lore", "Confessional", "Barrafina", "Donostia", "Royal Oak", "Thai Cafe"]
    
    var restaurantImages = ["cafedeadend.jpg", "homei.jpg", "teakha.jpg", "cafeloisl.jpg", "petiteoyster.jpg", "forkeerestaurant.jpg", "posatelier.jpg", "bourkestreetbakery.jpg", "haighschocolate.jpg", "palominoespresso.jpg", "upstate.jpg", "traif.jpg", "grahamavenuemeats.jpg", "wafflewolf.jpg", "fiveleaves.jpg", "cafelore.jpg", "confessional.jpg", "barrafina.jpg", "donostia.jpg", "royaloak.jpg", "thaicafe.jpg"]

    var restaurantLocations = ["Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Sydney", "Sydney", "Sydney", "New York", "New York", "New York", "New York", "New York", "New York", "New York", "London", "London", "London", "London"]
    
    var restaurantTypes = ["Coffee & Tea Shop", "Cafe", "Tea House", "Austrian / Causual Drink", "French", "Bakery", "Bakery", "Chocolate", "Cafe", "American / Seafood", "American", "American", "Breakfast & Brunch", "Coffee & Tea", "Coffee & Tea", "Latin American", "Spanish", "Spanish", "Spanish", "British", "Thai"]

    var restaurantIsVisited = [Bool](repeating: false, count: 21)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.restaurantNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomTableViewCell
        
        // Configure the cell...
        cell.nameLabel.text = restaurantNames[(indexPath as NSIndexPath).row]
        cell.thumbnailImageView.image = UIImage(named: restaurantImages[(indexPath as NSIndexPath).row])
        cell.locationLabel.text = restaurantLocations[(indexPath as NSIndexPath).row]
        cell.typeLabel.text = restaurantTypes[(indexPath as NSIndexPath).row]
        cell.favorIconImageView.isHidden = !restaurantIsVisited[(indexPath as NSIndexPath).row]

        // Circular image
        cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.frame.size.width / 2
        cell.thumbnailImageView.clipsToBounds = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Create an option menu as an action sheet
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        
        // Add Cancel action to the menu
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        // Add Call action to the menu
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            
            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the call feature is not available yet. Please retry later.", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
            
        }
        
        let callAction = UIAlertAction(title: "Call " + "123-000-\((indexPath as NSIndexPath).row)", style: UIAlertActionStyle.default, handler: callActionHandler)
        optionMenu.addAction(callAction)
        
        // Add I've been here action to the menu
        let isVisitedTitle = restaurantIsVisited[(indexPath as NSIndexPath).row] ? "I haven't been to here before" : "I've been here"
        let isVisitedAction = UIAlertAction(title: isVisitedTitle, style: .default, handler: {
            (action:UIAlertAction) -> Void in
            
            let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
            
            // Toggle checkmark
            self.restaurantIsVisited[(indexPath as NSIndexPath).row] = self.restaurantIsVisited[(indexPath as NSIndexPath).row] ? false : true
            cell.favorIconImageView.isHidden = !self.restaurantIsVisited[(indexPath as NSIndexPath).row]
        })
        optionMenu.addAction(isVisitedAction)

        // Display the menu
        self.present(optionMenu, animated: true, completion: nil)
        
        // Deselect the cell
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.restaurantNames.remove(at: (indexPath as NSIndexPath).row)
            self.restaurantLocations.remove(at: (indexPath as NSIndexPath).row)
            self.restaurantTypes.remove(at: (indexPath as NSIndexPath).row)
            self.restaurantIsVisited.remove(at: (indexPath as NSIndexPath).row)
            self.restaurantImages.remove(at: (indexPath as NSIndexPath).row)

            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction] {
        
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share", handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in

            let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .actionSheet)
            let twitterAction = UIAlertAction(title: "Twitter", style: .default, handler: { action -> Void in
                guard SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) else {
                    let alertMessage = UIAlertController(title: "Twitter Unavailable", message: "You haven't registered your Twitter account. Please go to Settings > Twitter to create one.", preferredStyle: .alert)
                    alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertMessage, animated: true, completion: nil)
                    return
                }
                
                let tweetComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
                tweetComposer.setInitialText(self.restaurantNames[indexPath.row])
                tweetComposer.add(UIImage(named: self.restaurantNames[indexPath.row]))
                self.present(tweetComposer, animated: true, completion: nil)
            })
            let facebookAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.default, handler: { action -> Void in
                guard SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) else {
                    let alertMessage = UIAlertController(title: "Facebook Unavailable", message: "You haven't registered your Facebook account. Please go to Settings > Facebook to create one.", preferredStyle: .alert)
                    alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertMessage, animated: true, completion: nil)
                    return
                }
                
                let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
                facebookComposer.setInitialText(self.restaurantNames[indexPath.row])
                facebookComposer.add(UIImage(named: self.restaurantNames[indexPath.row]))
                facebookComposer.add(URL(string: "http://www.appcoda.com"))
                self.present(facebookComposer, animated: true, completion: nil)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
            shareMenu.addAction(twitterAction)
            shareMenu.addAction(facebookAction)
            shareMenu.addAction(cancelAction)
            
            self.present(shareMenu, animated: true, completion: nil)
            }
        )
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete",handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in

            // Delete the row from the data source
            self.restaurantNames.remove(at: (indexPath as NSIndexPath).row)
            self.restaurantLocations.remove(at: (indexPath as NSIndexPath).row)
            self.restaurantTypes.remove(at: (indexPath as NSIndexPath).row)
            self.restaurantIsVisited.remove(at: (indexPath as NSIndexPath).row)
            self.restaurantImages.remove(at: (indexPath as NSIndexPath).row)

            self.tableView.deleteRows(at: [indexPath], with: .fade)

            }
        )
        
        shareAction.backgroundColor = UIColor(red: 255.0/255.0, green: 166.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)

        return [deleteAction, shareAction]
    }

    

}
