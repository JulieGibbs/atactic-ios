//
//  CampaignInfoViewController.swift
//  
//
//  Created by Jaime Lucea on 07/12/2018.
//

import Foundation
import UIKit

class CampaignInfoViewController : UIViewController {
    
    @IBOutlet var administratorName: UILabel!
    @IBOutlet var adminRoleLabel: UILabel!
    
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var daysSinceStartLabel: UILabel!
    
    @IBOutlet var deadlineLabel: UILabel!
    @IBOutlet var daysLeftLabel: UILabel!
    
    var campaign: CampaignStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print("CampaignInfoViewController did load")
        displayData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        // print("CampaignInfoViewController did appear")
    }
    
    func displayData(){
        if (campaign != nil) {
            administratorName.text = campaign!.owner.firstName + " " + campaign!.owner.lastName
            adminRoleLabel.text = campaign!.owner.position
            
            // Parse and print the campaign's start date
            if let startDate = DateUtils.parseISODate(isoDateString: campaign!.startDate) {
                startDateLabel.text = DateUtils.toDateString(date: startDate)
                
                // Get current date
                // let currentDate = Date()
                
                // Calculate days of difference between the two dates
                /*
                 let calendar = Calendar.current
                 let date1 = calendar.startOfDay(for: currentDate)
                 let date2 = calendar.startOfDay(for: parsedEndDate!)
                 let daysOfDiff = calendar.dateComponents([.day], from: date1, to: date2).day
                 
                 remainingDaysLabel.text = "Faltan \(daysOfDiff!) días"
                 */
                
            } else {
                startDateLabel.isHidden = true
            }
            
            // Parse and print the campaign's end date (deadline)
            if let endDate = DateUtils.parseISODate(isoDateString: campaign!.endDate) {
                deadlineLabel.text = DateUtils.toDateString(date: endDate)
                
                // Get current date
                // let currentDate = Date()
                
                // Calculate days of difference between the two dates
                /*
                 let calendar = Calendar.current
                 let date1 = calendar.startOfDay(for: currentDate)
                 let date2 = calendar.startOfDay(for: parsedEndDate!)
                 let daysOfDiff = calendar.dateComponents([.day], from: date1, to: date2).day
                 
                 remainingDaysLabel.text = "Faltan \(daysOfDiff!) días"
                 */
                
            } else {
                deadlineLabel.isHidden = true
            }
        }
    }
    
    
}
