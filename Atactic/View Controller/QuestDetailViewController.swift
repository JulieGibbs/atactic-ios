//
//  QuestDetailViewController.swift
//  Atactic
//
//  Created by Jaime on 29/12/17.
//  Copyright © 2017 ATACTIC. All rights reserved.
//

import UIKit

class QuestDetailViewController: UIViewController {

    var quest : Participation!
    
    @IBOutlet var questTitleLabel: UILabel!
    @IBOutlet var questBriefingLabel: UILabel!
    @IBOutlet var progressIndicator: KDCircularProgress!
    @IBOutlet var progressLabel: UILabel!
    
    @IBOutlet var containerViewA: UIView!
    
    
    @IBOutlet var containerViewB: UIView!
    @IBOutlet var containerViewC: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        printQuestData()
    }
    
    //
    // By overriding the prepare for segue, we can access the QuestTargetsSegmentController
    //  that manages the Target List container view in the Campaign Detail screen
    //  and add the Participation ID as a parameter in the segue
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // print("QuestDetailViewController - Preparing for segue")
        if segue.identifier == "GoToTargetsSegue" {
            if let dc = segue.destination as? QuestTargetsSegmentController {
                // print("QuestDetailViewController - (Segue) I have access to the Target Segment Controller")
                // print("QuestDetailViewController - (Segue) Will send the participation ID: \(quest.participationId)")
                dc.participationId = quest.participationId
            }
        } else if (segue.identifier == "showInfo") {
            if let dc = segue.destination as? CampaignInfoViewController {
                print("Preparing for segue show Info")
                dc.campaign = quest.campaign
                // dc.displayData(campaign: quest.campaign)
            }
        }
    }
    
    func printQuestData() {
        
        // Display Campaign name and Briefing
        questTitleLabel.text = quest.campaign.name
        questBriefingLabel.text = quest.campaign.summary
        
        // Set progress values for progress label text and circular indicator angle
        let prgr  = Double(quest.currentProgress)
        progressLabel.text = String(format: "%.0f", prgr * 100) + "%"
        progressIndicator.angle = prgr * 360.0
        progressIndicator.animate(fromAngle: 0, toAngle: prgr * 360.0, duration: 1) { (completed) in }
        
        // Display administrator info
        /*
        let adminNameLabel: UILabel = containerViewA.subviews[0].subviews[1] as! UILabel
        let adminTitleLabel: UILabel = containerViewA.subviews[0].subviews[2] as! UILabel
        adminNameLabel.text = quest.campaign.owner.firstName + " " + quest.campaign.owner.lastName
        adminTitleLabel.text = quest.campaign.owner.position
        */
        // Display deadline info
        /*
        let endDateLabel: UILabel =
            containerViewA.subviews[0].subviews[4] as! UILabel
        let remainingDaysLabel: UILabel =
            containerViewA.subviews[0].subviews[5] as! UILabel
        let endDateStr = quest.campaign.endDate
        */
        
        // Format date
        /*
        let endDateSubstr = String(endDateStr.split(separator: "T")[0])
        let sourceFormatter = DateFormatter()
        sourceFormatter.dateFormat = "yyyy-MM-dd"
        let parsedEndDate = sourceFormatter.date(from: endDateSubstr)
        let printableFormatter = DateFormatter()
        printableFormatter.dateFormat = "dd'/'M'/'yyyy"
        
        endDateLabel.text = printableFormatter.string(from: parsedEndDate!)
        */
        // Get current date
        // let currentDate = Date()
        
        // Calculate days of difference between the two dates
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
        // let targetListDataHandler = TargetListDataHandler(viewController: self.containerViewC)
        
        // let statusMessageTextView : UITextView = containerViewC.subviews[0].subviews[0] as! UITextView
        
        // statusMessageTextView.text = "Quest targets go here"
    }
    
    //
    // Segmented control management
    //
    @IBAction func showView(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerViewA.alpha = 1
                self.containerViewB.alpha = 0
                self.containerViewC.alpha = 0
            })
        } else if sender.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerViewA.alpha = 0
                self.containerViewB.alpha = 1
                self.containerViewC.alpha = 0
            })
        } else if sender.selectedSegmentIndex == 2 {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerViewA.alpha = 0
                self.containerViewB.alpha = 0
                self.containerViewC.alpha = 1
            })
        }
        
    }

}
