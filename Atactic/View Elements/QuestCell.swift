//
//  QuestCell.swift
//  Atactic
//
//  Created by Jaime on 28/12/17.
//  Copyright © 2017 ATACTIC. All rights reserved.
//

import UIKit

class QuestCell: UITableViewCell {
    
    @IBOutlet var questNameLabel: UILabel!
    @IBOutlet var questSummaryLabel: UILabel!
    @IBOutlet var currentStepLabel: UILabel!
    @IBOutlet var totalStepsLabel: UILabel!

    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var progressCircle: KDCircularProgress!
    
    
}

