//
//  LoginHandler.swift
//  Atactic
//
//  Created by Jaime Lucea on 20/8/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class LoginHandler {
    
    let viewController : LoginViewController
    
    init (view: LoginViewController) {
        self.viewController = view
    }
    
    /*
     * Prepares a login request for the ATACTIC API and sends it asynchronously.
     * In case of success, it performs a segue to enter Atactic. Otherwise, prints the corresponding error.
     */
    func attemptLogin(username: String, password: String) {
        
        let loginRequest = LoginRequest(user: username, pass: password)
        print("LoginHandler - Request ready - \(loginRequest.getURLString())")
        
        
        // Execute the authentication request asynchronously
        let task = URLSession.shared.dataTask(with: loginRequest.request,
           completionHandler: { (data, response, error) in
                                                
                if let httpStatus = response as? HTTPURLResponse {   // There is a response from the server
                    print("LoginHandler - Response Status Code : \(httpStatus.statusCode)")
                    
                    if httpStatus.statusCode == 200 {
                        print("LoginHandler - Authentication response OK")
                        let responseStr = String(data: data!, encoding: String.Encoding.utf8)
                        let userId = Int(responseStr!)!
                        print("LoginHandler - User ID = \(userId)")
                        
                        // Run in main queue
                        DispatchQueue.main.async { () -> Void in
                            // Store username, password and user ID in UserDefaults.standard
                            print("LoginHandler - Storing user credentials")
                            UserDefaults.standard.set(username, forKey: "username")
                            UserDefaults.standard.set(password, forKey: "password")
                            UserDefaults.standard.set(userId, forKey: "uid")
                            
                            // Success: Redirect to table view
                            self.viewController.enterApp()
                        }
                    } else {
                        // Error - Authentication attempt failed
                        print("LoginHandler - Authentication response NOT ok: \(httpStatus.statusCode)")
                        
                        // Run UI updates on the main queue
                        DispatchQueue.main.async { () -> Void in
                            // Show error message
                            self.viewController.displayErrorMessage(message: "Datos de acceso inválidos")
                        }
                    }
                }else{
                    // Error - Could not connect with server
                    // Run UI updates on the main queue
                    DispatchQueue.main.async { () -> Void in
                        // Show error message
                        self.viewController.displayErrorMessage(message: "No se ha podido conectar con el servidor")
                    }
                }
        })
        task.resume()
    }
    
    
}

