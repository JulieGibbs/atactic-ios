//
//  TabBarController.swift
//  Atactic
//
//  Created by Jaime on 25/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import UIKit

class LaunchController : UIViewController, AuthenticationController {
    
    var recoveredUserName : String?
    var recoveredPassword : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LaunchController - Did load")
        //
        // LaunchController is the pre-defined entry point for the app.
        // Upon loading, it will check for stored credentials in the cache (UserDefaults).
        //
        print("LaunchController - Searching for stored user credentials")
        recoveredUserName = UserDefaults.standard.string(forKey: "username")
        recoveredPassword = UserDefaults.standard.string(forKey: "password")
        
        if (recoveredUserName != nil && recoveredPassword != nil){
            //
            // In case stored credentials are found, try to authenticate the user with those credentials,
            //  because they might no longer be valid.
            //
            print("LaunchController - Recovered credentials for user: \(recoveredUserName!)")
            print("LaunchController - Attempting login with recovered credentials")
            let loginHandler = LoginHandler(view: self)
            loginHandler.attemptLogin(username: recoveredUserName!, password: recoveredPassword!)
            
        }else{
            //
            // In case Launch Controller is unable to recover credentials, simply redirect to the login screen
            //
            print("LaunchController - No stored credentials found. Redirecting to login screen...")
            goToLoginScreen()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // print("LaunchController - Did appear")
    }
    
    //
    // If authentication is successful, store credentials, request Tenant's configuration and enter app
    //
    func onAuthenticationSucess(token: String) {
        let userId = Int(token)!
        
        print("LaunchController - Authentication successful")
        LocationController.global.start()
        
        loadConfiguration(userId: userId)
        storeUserCredentials(token: token, username: recoveredUserName!, password: recoveredPassword!)
        enterApp()
    }
    
    //
    // On authentication failure, just return to login screen
    //
    func onAuthenticationFailure(message: String?) {
        print("LaunchController - Authentication failed")
        goToLoginScreen()
    }
    
    func enterApp() {
        print("LaunchController - Entering app...")
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "loadTabBar", sender: self)
        }
    }
    
    func goToLoginScreen(){
        print("LaunchController - Redirecting to login screen...")
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "goToLoginSegue", sender: self)
        }
    }
    
    func loadConfiguration(userId: Int){
        print("LaunchController - Requesting configuration for user \(userId)")
        let configHandler = ConfigurationHandler()
        configHandler.getConfiguration(userId: userId)
    }
    
    //
    // Store username, password and user ID in UserDefaults.standard
    //
    func storeUserCredentials(token: String, username: String, password: String){
        print("LaunchController - Storing user credentials")
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(token, forKey: "uid")
    }
    
    
}
