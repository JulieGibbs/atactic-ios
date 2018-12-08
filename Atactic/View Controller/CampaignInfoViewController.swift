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
    
    @IBOutlet var deadlineLabel: UILabel!
    @IBOutlet var daysLeftLabel: UILabel!
    
    var campaign: CampaignStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CampaignInfoViewController did load")
        displayData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        print("CampaignInfoViewController did appear")
    }
    
    func displayData(){
        if (campaign != nil) {
            administratorName.text = campaign!.owner.firstName + " " + campaign!.owner.lastName
            adminRoleLabel.text = campaign!.owner.position
            
            if let endDate = DateUtils.parseISODate(isoDateString: campaign!.endDate) {
                deadlineLabel.text = DateUtils.toDateAndTimeString(date: endDate)
            } else {
                deadlineLabel.isHidden = true
            }
        }
        
        /*
         let calendar = Calendar.current
         let date1 = calendar.startOfDay(for: currentDate)
         let date2 = calendar.startOfDay(for: parsedEndDate!)
         let daysOfDiff = calendar.dateComponents([.day], from: date1, to: date2).day
         
         remainingDaysLabel.text = "Faltan \(daysOfDiff!) días"
         
         let longDescriptionTextField = containerViewB.subviews[0].subviews[0] as! UITextView
         longDescriptionTextField.text = quest.campaign.description
         longDescriptionTextField.setContentOffset(CGPoint.zero, animated: false)
         */

        
        
    }
    
    
}
