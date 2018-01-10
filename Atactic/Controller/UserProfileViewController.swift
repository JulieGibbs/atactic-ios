//
//  UserProfileViewController.swift
//  Atactic
//
//  Created by Jaime on 1/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    let fullname = "Jaime Lucea Quiñones"
    let position = "Delegado Comercial"
    let score = 139
    let rank = 4

    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var scoreIndicator: UILabel!
    @IBOutlet var rankIndicator: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Fill views with data
        fullNameLabel.text = fullname
        positionLabel.text = position
        scoreIndicator.text = "\(score)"
        rankIndicator.text = "\(rank)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutSegue" {
            print("Loging out - Removing stored credentials")
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "password")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
