//
//  QuestCell.swift
//  Atactic
//
//  Created by Jaime on 28/12/17.
//  Copyright © 2017 ATACTIC. All rights reserved.
//

import UIKit

class ParticipationCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var briefingLabel: UILabel!

    @IBOutlet var priorityLabel: UILabel!
    @IBOutlet var deadlineLabel: UILabel!
    
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var progressCircle: KDCircularProgress!
    
    @IBOutlet var scoreIcon: UIImageView!
    @IBOutlet var scoreLabel: UILabel!
    
}

