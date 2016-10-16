//
//  AnimalTableViewController.swift
//  IndexedTableDemo
//
//  Created by Simon Ng on 17/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import UIKit

class AnimalTableViewController: UITableViewController {
    
    let animals = ["Bear", "Black Swan", "Buffalo", "Camel", "Cockatoo", "Dog", "Donkey", "Emu", "Giraffe", "Greater Rhea", "Hippopotamus", "Horse", "Koala", "Lion", "Llama", "Manatus", "Meerkat", "Panda", "Peacock", "Pig", "Platypus", "Polar Bear", "Rhinoceros", "Seagull", "Tasmania Devil", "Whale", "Whale Shark", "Wombat"]
    var animalDict = [String: [String]]()
    var animalSectionTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAnimalDict()
        print(animalSectionTitles)
        print(animalDict)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return animals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 

        // Configure the cell...
        cell.textLabel?.text = animals[(indexPath as NSIndexPath).row]
        
        // Convert the animal name to lower case and 
        // then replace all occurences of a space with an underscore
        let imageFilename = animals[(indexPath as NSIndexPath).row].lowercased().replacingOccurrences(of: " ", with: "_", options: [], range: nil)
        cell.imageView?.image = UIImage(named: imageFilename)

        return cell
    }
    
    // Helper Methods
    
    func createAnimalDict() {
        for animal in animals {
            // Get the first letter of the animal name and build the dictionary
            let index = animal.index(animal.startIndex, offsetBy: 1)
            let animalKey = animal.substring(to: index)
            
            if var animalValues = animalDict[animalKey] {
                animalValues.append(animal)
                animalDict[animalKey] = animalValues
            } else {
                animalDict[animalKey] = [animal]
            }
        }
        
        animalSectionTitles = [String](animalDict.keys)
        animalSectionTitles = animalSectionTitles.sorted(by: { $0 > $1 })
    }
    

}
