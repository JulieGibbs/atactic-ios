//
//  ActivityRegisterViewController.swift
//  Atactic
//
//  Created by Jaime on 14/3/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import UIKit

class ActivityRegisterViewController : UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var activities : [VisitStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ActivityRegisterViewController loaded - Requesting list of visits to DataHandler...")
        
        //
        // Instantiate a data handler upon loading this View Controller,
        //  and call the handler's getData() function for it to provide the data to display
        //
        let dataHandler = ActivityRegisterDataHandler(viewController: self)
        dataHandler.getData()
    }
    
    //
    // Called from the data handler to set the data to display
    //
    func setData(listOfActivities: [VisitStruct]) {
        print("ActivityRegisterViewController - Setting data to display")
        print("\(listOfActivities.count) activities will be displayed")
        self.activities = listOfActivities
        self.tableView.reloadData()
    }
    
    func setError(errorMessage: String) {
        // TODO display error
        
    }
    
}

//
// This extension makes the view controller implement functions required to display and manage a table and its cells
//
extension ActivityRegisterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let visit = activities[indexPath.row]
        let qID = "VCell"
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: qID, for: indexPath) as! ActivityCell
        
        cell.accountNameLabel.text = visit.account.name
        
        let formattedDateAndTime = DateUtils.toFormattedDateAndTime(unformattedTimeStamp: visit.timeReported)
        cell.activityDateLabel.text = formattedDateAndTime

        return cell
    }
    
}


