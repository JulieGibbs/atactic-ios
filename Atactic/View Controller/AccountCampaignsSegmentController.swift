//
//  AccountCampaignsSegmentController.swift
//  Atactic
//
//  Created by Jaime Lucea on 01/10/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation
import UIKit

class AccountCampaignsSegmentController : UIViewController {
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var accountId : Int = 0
    var campaigns : [Participation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("AccountCampaignsSegmentController - Did load (accountId = \(accountId)")
        let dataHandler = AccountCampaignsDataHandler(viewController: self)
        dataHandler.getData(accountId: accountId)
    }
    
    func displayData(participations: [Participation]) {
        self.messageLabel.isHidden = true
        campaigns = participations
        
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    func displayMessage(message: String) {
        self.tableView.isHidden = true
        self.messageLabel.text = message
        self.messageLabel.isHidden = false
    }
    
}

//
// This extension makes the view controller implement functions required to display and manage a table and its cells
//
extension AccountCampaignsSegmentController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.campaigns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let campaign = campaigns[indexPath.row]
        let qID = "SQCell"
        let cell = self.tableView.dequeueReusableCell(withIdentifier: qID, for: indexPath) as! SimpleQuestCell
        
        cell.campaignNameLabel.text = campaign.campaign.name
        
        if let deadline = DateUtils.parseISODate(isoDateString: campaign.campaign.endDate){
            cell.campaignDeadlineLabel.text = DateUtils.toDateString(date: deadline)
        }else{
            cell.campaignDeadlineLabel.isHidden = true
        }
        // cell.campaignDeadlineLabel.text = DateUtils.toFormattedDate(timestamp: campaign.campaign.endDate)
        
        cell.progressLabel.text = String(format: "%.1f", campaign.currentProgress * 100) + " %"

        return cell
    }
    
}

