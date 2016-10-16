//
//  RestaurantTableViewController.swift
//  MapKitDirectionDemo
//
//  Created by Simon Ng on 18/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {

    var restaurants:[Restaurant] = [
        Restaurant(name: "Buttermilk Channel", category: "American", address: "524 Ct St, Brooklyn, NY 11231", image: "buttermilk_channel.jpg"),
        Restaurant(name: "Buddakan", category: "Asian Fusion", address: "75 9th Ave, New York, NY 10011", image: "buddakan.jpg"),
        Restaurant(name: "Paprika", category: "Italian", address: "110 St Marks Pl New York, NY 10009", image: "paprika.jpg"),
        Restaurant(name: "Extra Virgin", category: "Greek, Italian", address: "259 W 4th St, New York, NY 10014", image: "extra_virgin.jpg"),
        Restaurant(name: "Luigi Pizzeria", category: "Pizza, Italian", address: "326 Dekalb Ave, Brooklyn, NY 11205", image: "luigi_pizzeria.jpg"),
        Restaurant(name: "Prince St Pizza", category: "Pizza, Italian", address: "27 Prince St, New York, NY 10012", image: "prince_st_pizza.jpg"),
        Restaurant(name: "Merilu Pizza Al Metro", category: "Pizza, Italian", address: "791 9th Ave, New York, NY 10019", image: "merilu_pizza_al_metro.jpg"),
        Restaurant(name: "Pure Thai Cookhouse", category: "Thai", address: "766 9th Ave, New York, NY 10019", image: "pure_thai_cookhouse.jpg"),
        Restaurant(name: "Ayada Thai", category: "Thai", address: "77-08 Woodside Ave, Elmhurst, NY 11373", image: "ayada_thai.jpg"),
        Restaurant(name: "Los Perros Locos", category: "Hot Dogs", address: "201 Allen St, New York, NY 10002", image: "los_perros_locos.jpg"),
        Restaurant(name: "Crif Dogs", category: "Hot Dogs", address: "113 Saint Marks Pl, New York, NY 10009", image: "crif_dogs.jpg"),
        Restaurant(name: "Pates Et Traditions", category: "French", address: "52 Havemeyer St, Brooklyn, NY 11211", image: "pates_et_traditions.jpg"),
        Restaurant(name: "Bistro Petit", category: "French", address: "170 S 3rd St, Brooklyn, NY 11211", image: "bistro_petit.jpg"),
        Restaurant(name: "Doughnut Plant", category: "Bakeries, Donuts", address: "379 Grand St, New York, NY 10002", image: "doughnut_plant.jpg"),
        Restaurant(name: "Shake Shack", category: "Burgers", address: "E 23rd St & Madison Ave, New York, NY 10010", image: "shake_shack.jpg"),
        Restaurant(name: "Two 8 Two", category: "Burgers", address: "282 Atlantic Ave, Brooklyn, NY 11201", image: "two_8_two.jpg")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return restaurants.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 

        // Configure the cell...
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.name
        cell.detailTextLabel?.text = restaurant.category
        cell.imageView?.image = UIImage(named: restaurant.image)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showLocation" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! UINavigationController
                let mapViewController = destinationController.childViewControllers.first as! MapViewController
                mapViewController.restaurant = restaurants[indexPath.row]
            }
        }
    }

    
    @IBAction func homeScreen(segue:UIStoryboardSegue) {
    }
}
