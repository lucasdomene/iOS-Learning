//
//  KivaLoanTableViewController.swift
//  KivaLoan
//
//  Created by Simon Ng on 20/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import UIKit

class KivaLoanTableViewController: UITableViewController {

    let kivaLoanURL = "https://api.kivaws.org/v1/loans/newest.json"
    var loans = [Loan]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLatestLoans()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loans.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! KivaLoanTableViewCell
        let loan = loans[indexPath.row]
        
        cell.nameLabel.text = loan.name
        cell.useLabel.text = loan.use
        cell.amountLabel.text = "$\(loan.amount)"
        cell.countryLabel.text = loan.country
        
        return cell
    }
    
    // Data Fetcher
    
    func getLatestLoans() {
        let request = URLRequest(url: URL(string: kivaLoanURL)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                self.loans = self.parseJSONData(data: data)
                
                OperationQueue.main.addOperation({ 
                    self.tableView.reloadData()
                })
            }
        }
        
        task.resume()
    }
    
    // Parse
    
    func parseJSONData(data: Data) -> [Loan] {
        var loans = [Loan]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
            
            let jsonLoans = jsonResult?["loans"] as! [AnyObject]
            for jsonLoan in jsonLoans {
                let name = jsonLoan["name"] as! String
                let use = jsonLoan["use"] as! String
                let amount = jsonLoan["loan_amount"] as! Int
                let location = jsonLoan["location"] as! [String: AnyObject]
                let country = location["country"] as! String
                
                let loan = Loan(name: name, country: country, use: use, amount: amount)
                loans.append(loan)
            }
        } catch {
            print(error)
        }
        print(loans)
        return loans
    }
    
}
