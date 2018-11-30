//
//  TabBarController.swift
//  Atactic
//
//  Created by Jaime on 25/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import UIKit

class CentralController : UIViewController, AuthenticationController {
    
    var recoveredUserName : String?
    var recoveredPassword : String?
    
    //
    // This property indicates whether the Central Controller has been loaded
    //  after the user entered credentials in the Login screen (comingFromLoginScreen = true)
    //  or if Central Controller is loaded as the usual entry point of the application.
    //
    // var comingFromLoginScreen : Bool = false
    
    
    override func viewDidLoad() {
        // super.viewDidLoad()
        
        print("CentralController - Did load")
        //
        // CentralController is being accessed directly as the pre-defined entry point for the app.
        // In this situation, it will check for stored credentials in the cache (UserDefaulst).
        //
        print("CentralController - Searching for stored user credentials")
        recoveredUserName = UserDefaults.standard.string(forKey: "username")
        recoveredPassword = UserDefaults.standard.string(forKey: "password")
        
        if (recoveredUserName != nil && recoveredPassword != nil){
            //
            // In case stored credentials are found, try to authenticate the user with those credentials.
            //  because they might no longer be valid.
            //
            print("CentralController - Recovered credentials for user: \(recoveredUserName!)")
            print("CentralController - Attempting login with recovered credentials")
            let loginHandler = LoginHandler(view: self)
            loginHandler.attemptLogin(username: recoveredUserName!, password: recoveredPassword!)
            
        }else{
            //
            // In case Central Controller is unable to recover credentials, simply redirect to the login screen
            //
            print("CentralController - No stored credentials found. Redirecting to login screen...")
            goToLoginScreen()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("CentralController - Did appear")
    }
    
    
    func onAuthenticationSucess(token: String) {
        let userId = Int(token)!
        
        print("CentralController - Authentication successful")
        LocationController.global.start()
        
        loadConfiguration(userId: userId)
        storeUserCredentials(token: token, username: recoveredUserName!, password: recoveredPassword!)
        enterApp()
    }
    
    func onAuthenticationFailure(message: String?) {
        print("CentralController - Authentication failed")
        goToLoginScreen()
    }
    
    func enterApp() {
        print("CentralController - Entering app...")
        self.performSegue(withIdentifier: "loadTabBar", sender: self)
    }
    
    func goToLoginScreen(){
        print("CentralController - Redirecting to login screen...")
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    func loadConfiguration(userId: Int){
        print("CentralController - Requesting configuration for user \(userId)")
        let configHandler = ConfigurationHandler()
        configHandler.getConfiguration(userId: userId)
    }
    
    //
    // Store username, password and user ID in UserDefaults.standard
    //
    func storeUserCredentials(token: String, username: String, password: String){
        print("CentralController - Storing user credentials")
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(token, forKey: "uid")
    }
    
    /*
     * Prepares a login request for the ATACTIC API and sends it asynchronously.
     * In case of error (invalid credentials or unreachable server), redirects to login screen
     */
    /*
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
    } */
    
    
}
