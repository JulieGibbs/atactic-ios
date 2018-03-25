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
        
        let dataHandler = TargetListDataHandler(viewController: self)
        dataHandler.getData()
    }
    
    //
    // Set the data to display in the view
    //
    func setData(targets: [ParticipationTargetStruct]) {
        print("TargetListViewController - Received data to display")
        print("\(targets.count) priority targets will be displayed")
        self.targets = targets
        self.tableView.reloadData()
    }
    
    func setError(errorMessage: String) {
        // TODO display error
        
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
        
        if (target.account.distance == -1) {
            cell.distanceToTargetLabel.text = ""
        } else {
            let roundedValue = Int(round(target.account.distance))
            cell.distanceToTargetLabel.text = "\(roundedValue)m"
        }
        return cell
    }
    
}










