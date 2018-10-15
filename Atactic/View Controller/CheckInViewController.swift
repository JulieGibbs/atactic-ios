//
//  CheckInViewController.swift
//  Atactic
//
//  Created by Jaime Lucea on 15/10/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation
import UIKit

class CheckInViewController : UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CheckInViewController - did load")
        
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        print("CheckInViewController - Cancel button pressed")
        performSegue(withIdentifier: "backToMapSegue", sender: self)
    }
    
    @IBAction func checkInButtonPressed(_ sender: Any) {
        
        print("CheckInViewController - CheckIn button pressed")
        
        
    }
}
