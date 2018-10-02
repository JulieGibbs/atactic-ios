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
    
    @IBOutlet var errorMsgTextView: UITextView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var targets : [Target] = []
    
    /*
    required init?(coder aDecoder: NSCoder) {
        targets = []
        super.init(coder: aDecoder)
    }
    */
 
    override func viewDidLoad() {
        super.viewDidLoad()
        print()
        print("Target List View Controller loaded")
        
        self.tableView.isHidden = true
        self.activityIndicator.isHidden = false
        
        let dataHandler = TargetListDataHandler(viewController: self)
        dataHandler.getData()
    }
    
    //
    // Set the data to display in the view
    //
    func displayData(targets: [Target]) {
        print("TargetListViewController - Received data to display")
        
        self.targets = targets
        // print("\(targets.count) priority targets will be displayed")
        
        self.activityIndicator.isHidden = true
        self.tableView.isHidden = false
        
        self.tableView.reloadData()
    }
    
    func displayError(message: String) {
        self.tableView.isHidden = true
        self.activityIndicator.isHidden = true
        self.errorMsgTextView.text = message
        self.errorMsgTextView.isHidden = false
    }
    
    // Prepare for the showAccountDetail segue
    // by setting the quest data in the destination QuestDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAccountDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedAccount = self.targets[indexPath.row]
                let destinationViewContoller = segue.destination as! AccountDetailViewController
                destinationViewContoller.account = selectedAccount
            }
        }
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
        cell.accountAddressLabel.text = target.account.address + ", " + target.account.postalCode + ", " + target.account.city
        // cell.targetScore.text = "\(target.score)"
        
        if (target.account.distance == -1) {
            cell.distanceToTargetLabel.text = ""
        } else {
            let roundedValue = Int(round(target.account.distance))
            cell.distanceToTargetLabel.text = "\(roundedValue)m"
        }
        return cell
    }
    
}










