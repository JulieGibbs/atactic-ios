//
//  ActivityListPresenter.swift
//  Atactic
//
//  Created by Jaime Lucea on 25/12/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

protocol ActivityListPresenter {
    
    func displayData(activityList: [VisitStruct])
    
    func displayMessage(message: String)
    
}
