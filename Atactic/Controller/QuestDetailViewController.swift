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

        questTitleLabel.text = quest.campaign.name
        questBriefingLabel.text = quest.campaign.summary
        
        // Set progress values for progress label text and circular indicator angle
        let prgr = Double(quest.currentStep) / Double(quest.totalSteps)
        progressLabel.text = String(format: "%.0f", prgr * 100) + "%"
        
        progressIndicator.angle = prgr * 360.0
        progressIndicator.animate(fromAngle: 0, toAngle: prgr * 360.0, duration: 1) { (completed) in
        }
        
        let adminNameLabel: UILabel = containerViewA.subviews[0].subviews[1] as! UILabel
        let adminTitleLabel: UILabel = containerViewA.subviews[0].subviews[2] as! UILabel
        let endDateLabel: UILabel =
            containerViewA.subviews[0].subviews[4] as! UILabel
        let remainingDaysLabel: UILabel =
            containerViewA.subviews[0].subviews[5] as! UILabel
        
        adminNameLabel.text = quest.campaign.owner.firstName + " " + quest.campaign.owner.lastName
        adminTitleLabel.text = quest.campaign.owner.position
        endDateLabel.text = quest.campaign.endDate
        remainingDaysLabel.text = "Faltan X días"
        
        let longDescriptionTextField = containerViewB.subviews[0].subviews[0] as! UITextView
        longDescriptionTextField.text = quest.campaign.description
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
