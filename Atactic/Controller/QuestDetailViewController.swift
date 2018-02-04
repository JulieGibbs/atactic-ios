//
//  QuestDetailViewController.swift
//  Atactic
//
//  Created by Jaime on 29/12/17.
//  Copyright © 2017 ATACTIC. All rights reserved.
//

import UIKit

class QuestDetailViewController: UIViewController {

    var quest : QuestParticipationStruct!
    
    @IBOutlet var questTitleLabel: UILabel!
    @IBOutlet var questBriefingLabel: UILabel!
    @IBOutlet var progressIndicator: KDCircularProgress!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var containerViewA: UIView!
    @IBOutlet var containerViewB: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        printQuestData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func printQuestData() {
        
        questTitleLabel.text = quest.campaign.name
        questBriefingLabel.text = quest.campaign.summary
        
        // Set progress values for progress label text and circular indicator angle
        let prgr = Double(quest.currentStep) / Double(quest.totalSteps)
        progressLabel.text = String(format: "%.0f", prgr * 100) + "%"
        
        progressIndicator.angle = prgr * 360.0
        progressIndicator.animate(fromAngle: 0, toAngle: prgr * 360.0, duration: 1) { (completed) in }
        
        let adminNameLabel: UILabel = containerViewA.subviews[0].subviews[1] as! UILabel
        let adminTitleLabel: UILabel = containerViewA.subviews[0].subviews[2] as! UILabel
        let endDateLabel: UILabel =
            containerViewA.subviews[0].subviews[4] as! UILabel
        let remainingDaysLabel: UILabel =
            containerViewA.subviews[0].subviews[5] as! UILabel
        
        adminNameLabel.text = quest.campaign.owner.firstName + " " + quest.campaign.owner.lastName
        adminTitleLabel.text = quest.campaign.owner.position
        
        let endDateStr = quest.campaign.endDate
        
        // Format date
        let endDateSubstr = String(endDateStr.split(separator: "T")[0])
        let sourceFormatter = DateFormatter()
        sourceFormatter.dateFormat = "yyyy-MM-dd"
        let parsedEndDate = sourceFormatter.date(from: endDateSubstr)
        let printableFormatter = DateFormatter()
        printableFormatter.dateFormat = "dd'/'M'/'yyyy"
        
        endDateLabel.text = printableFormatter.string(from: parsedEndDate!)
        
        // Get current date
        let currentDate = Date()
        
        // Calculate days of difference between the two dates
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: currentDate)
        let date2 = calendar.startOfDay(for: parsedEndDate!)
        let daysOfDiff = calendar.dateComponents([.day], from: date1, to: date2).day
        
        remainingDaysLabel.text = "Faltan \(daysOfDiff!) días"
        
        let longDescriptionTextField = containerViewB.subviews[0].subviews[0] as! UITextView
        longDescriptionTextField.text = quest.campaign.description
    }
    
    //
    // Segmented control management
    //
    @IBAction func showView(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerViewA.alpha = 1
                self.containerViewB.alpha = 0
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.containerViewA.alpha = 0
                self.containerViewB.alpha = 1
            })
        }
        
    }

}
