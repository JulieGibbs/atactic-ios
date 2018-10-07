//
//  PasswordChangeViewController.swift
//  Atactic
//
//  Created by Jaime Lucea on 03/10/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation
import UIKit

class PasswordChangeViewController : UIViewController {
    
    @IBOutlet var newPassworddTextView: UITextField!
    @IBOutlet var passwordConfirmationTextView: UITextField!
    @IBOutlet var updatePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("PasswordChangeViewController did load")
    }
    
    
    @IBAction func updatePasswordButtonPressed(_ sender: Any) {
        
        print("Update password button pressed")
        
        // Perform validation
        if (newPassworddTextView.text == passwordConfirmationTextView.text) {
            print("PasswordChangeViewController - Password validation OK")
            changePassword()
        }else{
            print("PasswordChangeViewController - Wrong password confirmation")
        }
    }
    
    
    private func changePassword() {
        
        // Recover user's ID
        let recoveredUserId : Int = UserDefaults.standard.integer(forKey: "uid")
        
        let httpRequest = PasswordChangeRequest(userId: recoveredUserId, newPass: newPassworddTextView.text!)
        
        // Declare an asynchronous task that sends an HTTP request and handles the response
        let httpRequestTask = URLSession.shared.dataTask(with: httpRequest.getRequest()) { (data, response, error) in
            self.handleServerResponse(data: data, response: response, error: error)
        }
        
        // Execute asynchronous task
        httpRequestTask.resume()
    }
    
    
    private func handleServerResponse (data: Data?, response: URLResponse?, error: Error?) {
        
        print("PasswordChangeViewController - Handling server response")
        
        // Try cast to HTTP Response
        if let httpResponse = response as? HTTPURLResponse {
            
            print("PasswordChangeViewController - HTTP response received - \(httpResponse.statusCode)")
            if (httpResponse.statusCode == 200) {
                
                print("PasswordChangeViewController - Password successfuly updated")
            } else {
                print("PasswordChangeViewController - Response error code \(httpResponse.statusCode)")
            }
        } else {
            print("TargetListDataHandler - No response from server")
        }
    }
    
    
}


