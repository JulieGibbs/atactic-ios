//
//  ViewController.swift
//  Atactic
//
//  Created by Jaime Lucea on 29/8/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

protocol TargetListDisplay {
    
    func displayData(targets: [Target])
    
    func displayError(message: String)
    
}

