//
//  AccountActivitySegmentController.swift
//  Atactic
//
//  Created by Jaime Lucea on 25/12/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation
import UIKit

class AccountActivitySegmentController : UIViewController, ActivityListPresenter {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    var activities : [VisitStruct] = []
    var accountId : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AccountActivitySegmentController - Did load")
        
        // TODO - show loading indicator
        self.loadingIndicator.isHidden = false
        self.messageLabel.isHidden = true
        self.tableView.isHidden = true
        
        let recoveredUserId : Int = UserDefaults.standard.integer(forKey: "uid")
        // print("AccountActivitySegmentController - userId = \(recoveredUserId)")
        // print("AccountActivitySegmentController - accountId = \(accountId)")
        
        // Instantiate data handler and request data to display
        let dataHandler = ActivityDataHandler(dataPresenter: self)
        dataHandler.getActivities(userId: recoveredUserId, accountId: accountId)
    }
    
    
    func displayData(activityList: [VisitStruct]) {
        self.loadingIndicator.isHidden = true
        if (activityList.count == 0) {
            displayMessage(message: "No hay actividad relacionada con este cliente")
        } else {
            print("AccountActivitySegmentController - \(activityList.count) activities to be displayed")
            //activityTableView = ActivityTableView(table: tableView, data: activityList)
            //activityTableView.tableView.reloadData()
            self.messageLabel.isHidden = true
            self.activities = activityList
            self.tableView.reloadData()
            self.tableView.isHidden = false
            // messageLabel.text = "\(activityList.count) activities will be displayed here"
        }
    }
    
    func displayMessage(message: String) {
        self.loadingIndicator.isHidden = true
        self.tableView.isHidden = true
        self.messageLabel.isHidden = false
        messageLabel.text = message
    }

}


extension AccountActivitySegmentController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let visit = activities[indexPath.row]
        let qID = "ActCell"
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: qID, for: indexPath) as! ActivityCell
        
        // cell.accountNameLabel.text = visit.account.name
        
        if let parsedDate = DateUtils.parseISODate(isoDateString: visit.timeReported) {
            cell.activityDateLabel.text = DateUtils.toDateAndTimeString(date: parsedDate)
        }else{
            cell.activityDateLabel.text = visit.timeReported
        }
        
        cell.commentsLabel.text = visit.comments
        
        return cell
    }
    
}

