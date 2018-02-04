//
//  TargetListViewController.swift
//  Atactic
//
//  Created by Jaime on 4/2/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import UIKit

class TargetListViewController : UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var targets : [ParticipationTargetStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print()
        print("Target List View Controller loaded")
        
        loadTargets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    // Sends a request to the API and displays the resulting list of targets
    //
    func loadTargets() {
        
        // Recover user's ID
        let recoveredUserId = UserDefaults.standard.integer(forKey: "uid")
        
        // Build the Http request to the TargetAccounts service
        let request = RequestFactory.buildTargetAccountsRequest(userId: recoveredUserId)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let serverResponse = response as? HTTPURLResponse {
                print("TargetService response received - \(serverResponse.statusCode)")
                if (serverResponse.statusCode == 200) {
                    // DECODE JSON response
                    print("Decoding Target List from JSON response")
                    //print(String(data: data!, encoding: .utf8)!)
                    //print()
                    let decoder = JSONDecoder()
                    let targets = try! decoder.decode([ParticipationTargetStruct].self, from: data!)
                    print("TargetListViewController - Loaded \(targets.count) targets from the server")
                    
                    // Run UI updates in the main queue
                    DispatchQueue.main.async { () -> Void in
                        print("TargetListViewController: reloading table view data")
                        self.targets = targets
                        self.tableView.reloadData()
                    }
                } else {
                    print("Error code \(serverResponse.statusCode)")
                }
            } else {
                print("No response from server")
            }
        }
        task.resume()
    }
    
}

//
// This extension makes the view controller implement functions required to display and manage a table and its cells
//
extension TargetListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.targets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let target = targets[indexPath.row]
        let qID = "TCell"
        let cell = self.tableView.dequeueReusableCell(withIdentifier: qID, for: indexPath) as! TargetCell
        
        cell.accountNameLabel.text = target.account.name
        cell.accountAddressLabel.text = target.account.address
        cell.targetScore.text = "\(target.participation.campaign.visitScore)"
        cell.distanceToTargetLabel.text = "\(target.account.distance) m"

        return cell
    }
    
}










