//
//  QuestTargetsSegmentController.swift
//  Atactic
//
//  Created by Jaime Lucea on 23/8/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation
import UIKit

class QuestTargetsSegmentController : UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var errorMsgTextView: UITextView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var targets : [AccountStruct] = []
    
    var participationId : Int = 0
    
    /*
     required init?(coder aDecoder: NSCoder) {
     targets = []
     super.init(coder: aDecoder)
     }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.isHidden = true
        self.errorMsgTextView.isHidden = true
        self.activityIndicator.isHidden = false
        
        print("QuestTargetsSegmentController - Calling Data Handler")
        print("QuestTargetsSegmentController - Asking for targets for participation \(participationId)")
        let dataHandler = QuestTargetListDataHandler(viewController: self)
        dataHandler.getData()
    }
    
    //
    // Set the data to display in the view
    //
    func displayData(targets: [AccountStruct]) {
        print("QuestTargetsSegmentController - Received data")
        print("QuestTargetsSegmentController - \(targets.count) targets")
        // print("\(targets.count) priority targets will be displayed")
        self.targets = targets
        
        self.activityIndicator.isHidden = true
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    //
    // Hides the table and displays a message instead
    //
    func displayError(message: String) {
        self.tableView.isHidden = true
        self.activityIndicator.isHidden = true
        self.errorMsgTextView.text = message
        self.errorMsgTextView.isHidden = false
    }
    
}

//
// This extension makes the view controller implement functions required to display and manage a table and its cells
//
extension QuestTargetsSegmentController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.targets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // print("QuestTargetsSegmentController - Table View Row \(indexPath.row)")
        
        let target = targets[indexPath.row]
        let qID = "QTCell"
        let cell = self.tableView.dequeueReusableCell(withIdentifier: qID, for: indexPath) as! QuestTargetCell
        
        cell.accountNameLabel.text = target.name
        cell.accountAddressLabel.text = target.address
        
        /*
        cell.accountNameLabel.text = target.account.name
        cell.accountAddressLabel.text = target.account.address
        */
        // + ", " + target.account.postalCode
        // + ", " + target.account.city
        // cell.targetScore.text = "\(target.score)"
        
        /*
        if (target.account.distance == -1) {
            cell.distanceToTargetLabel.text = ""
        } else {
            let roundedValue = Int(round(target.account.distance))
            cell.distanceToTargetLabel.text = "\(roundedValue)m"
        }
         */
        return cell
    }
    
}









