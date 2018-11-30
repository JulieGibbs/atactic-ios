//
//  LoginHandler.swift
//  Atactic
//
//  Created by Jaime Lucea on 20/8/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class LoginHandler {
    
    let controller : AuthenticationController
    
    init (view: AuthenticationController) {
        self.controller = view
    }
    
    /*
     * Prepares a login request for the ATACTIC API and sends it asynchronously.
     * In case of success, it performs a segue to enter Atactic. Otherwise, prints the corresponding error.
     */
    func attemptLogin(username: String, password: String) {
        
        let loginRequest = LoginRequest(user: username, pass: password)
        print("LoginHandler - Request ready - \(loginRequest.getURLString())")
        
        //
        // Execute the authentication request asynchronously
        //
        let task = URLSession.shared.dataTask(with: loginRequest.request,
           completionHandler: { (data, response, error) in
            
                // Got a response from the server
                if let httpStatus = response as? HTTPURLResponse {
                    print("LoginHandler - Response Status Code : \(httpStatus.statusCode)")
                    
                    if httpStatus.statusCode == 200 {
                        
                        print("LoginHandler - Authentication response OK")
                        let responseStr = String(data: data!, encoding: String.Encoding.utf8)
                        let userId = Int(responseStr!)!
                        print("LoginHandler - User ID = \(userId)")

                        // Run in main queue
                        DispatchQueue.main.async { () -> Void in

                            // Tell controller to execute success scenario
                            self.controller.onAuthenticationSucess(token: "\(userId)")
                        }
                    } else {
                        // Error - Authentication attempt failed
                        print("LoginHandler - Authentication response NOT ok: \(httpStatus.statusCode)")
                        
                        //
                        // Run UI updates on the main queue
                        //
                        DispatchQueue.main.async { () -> Void in
                            // Show error message
                            self.controller.onAuthenticationFailure(message: "Datos de acceso inválidos")
                        }
                    }
                }else{
                    // Error - Could not connect with server
                    // Run UI updates on the main queue
                    DispatchQueue.main.async { () -> Void in
                        
                        self.controller.onAuthenticationFailure(message: "No se ha podido conectar con el servidor")
                    }
                }
        })
        
        //
        //
        task.resume()
    }
    
}

