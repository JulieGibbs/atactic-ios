//
//  NavigationController.swift
//  Atactic
//
//  Created by Jaime on 30/12/17.
//  Copyright © 2017 ATACTIC. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    var recoverCredentials : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Navigation Controller loaded")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Navigation Controller did appear")
        
        print("Searching for stored user credentials")
        let recoveredUserName = UserDefaults.standard.string(forKey: "username")
        let recoveredUserPassword = UserDefaults.standard.string(forKey: "password")
        
        if (recoveredUserName != nil && recoveredUserPassword != nil){
            print("Recovered credentials for user: \(recoveredUserName!)")
            // print("Recovered password: \(recoveredUserPassword!)")
            
            // TODO:
            // AUTHENTICATE user, using recovered credentials before continuing
            // just in case they are no longer valid
            // If authentication fails, redirect to login screen
            
        }else{
            print("No stored credentials found - Redirecting to login screen")
            
            // Redirect to login screen
            self.performSegue(withIdentifier: "redirectToLoginSegue", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
