//
//  TabBarController.swift
//  Atactic
//
//  Created by Jaime on 25/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import UIKit

class CentralController : UITabBarController {
    
    var comingFromLoginScreen : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Central Controller loaded")
        
        print("Starting Global Location Controller")
        LocationController.global.start()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print()
        print("Central Controller did appear")
        
        if (!comingFromLoginScreen) {
            print("Attempting to access internal app views directly")
            
            // Execute this only when Controller is being accessed directly
            // as the entry point for the app,
            // but NOT when user is coming from the login screen
            print("Searching for stored user credentials")
            let recoveredUserName = UserDefaults.standard.string(forKey: "username")
            let recoveredUserPassword = UserDefaults.standard.string(forKey: "password")
            
            if (recoveredUserName != nil && recoveredUserPassword != nil){
                print("Recovered credentials for user: \(recoveredUserName!)")
                // print("Recovered password: \(recoveredUserPassword!)")
                
                // AUTHENTICATE user, using recovered credentials before proceeding
                // just in case they are no longer valid.
                // If authentication fails, redirect to login screen
                print("Attempting login with recovered credentials")
                doLogin(username: recoveredUserName!, password: recoveredUserPassword!)
                
            }else{
                print("No stored credentials found - Redirecting to login screen")
                
                // Redirect to login screen
                self.performSegue(withIdentifier: "backToLoginSegue", sender: self)
            }
        }else{
            print("Central Controller: accessing app after Login screen. Credentials won't be checked at this point.")
        }
    }
    
    
    /*
     * Prepares a login request for the ATACTIC API and sends it asynchronously.
     * In case of error (invalid credentials or unreachable server), redirects to login screen
     */
    func doLogin(username: String, password: String) {
        
        let loginRequest = LoginRequest(user: username, pass: password)
        
        // Execute the authentication request asynchronously
        let task = URLSession.shared.dataTask(with: loginRequest.request, completionHandler: { (data, response, error) in
            
            if let httpStatus = response as? HTTPURLResponse {   // There is a response from the server
                print("Response Status Code : \(httpStatus.statusCode)")
                
                if httpStatus.statusCode == 200 {
                    print("Authentication response OK")
                    let responseStr = String(data: data!, encoding: String.Encoding.utf8)
                    let userId = Int(responseStr!)!
                    print("User ID = \(userId)")
                    
                } else {
                    print("Central Controller: Authentication response NOT ok: \(httpStatus.statusCode)")
                    
                    // Run in the main queue
                    DispatchQueue.main.async { () -> Void in
                        // Redirect to login screen
                        self.performSegue(withIdentifier: "backToLoginSegue", sender: self)
                    }
                }
            }else{
                print("No response from server")
                
                // Run in the main queue
                DispatchQueue.main.async { () -> Void in
                    // Redirect to login screen
                    self.performSegue(withIdentifier: "backToLoginSegue", sender: self)
                }
            }
        })
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
