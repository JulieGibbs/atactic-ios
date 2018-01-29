//
//  ViewController.swift
//  Atactic
//
//  Created by Jaime on 27/12/17.
//  Copyright © 2017 ATACTIC. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {

    @IBOutlet var usrnameTextField: UITextField!
    @IBOutlet var passwdTextField: UITextField!
    @IBOutlet var errorMessage: UILabel!
    
    // Local user database
    /*
    var users : [String : String] = ["jlucea": "jame",
                                    "merivu": "meri",
                                    "hconget": "hector"]
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login View Controller loaded")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        print("Login button pressed")
        
        // Recover user credential from UI Views
        let usr = usrnameTextField.text!
        let pwd = passwdTextField.text!
        print("username: " + usr)
        // print("password: " + pwd)
        
        errorMessage.isHidden = true
        errorMessage.text = ""
        
        // Execute login logic
        doLogin(username: usr, password: pwd)
    }
    
    /*
     * Prepares a login request for the ATACTIC API and sends it asynchronously.
     * In case of success, it performs a segue to enter Atactic. Otherwise, prints the corresponding error.
     */
    func doLogin(username: String, password: String) {
        
        let loginRequest = LoginRequest(user: username, pass: password)
        
        // Execute the authentication request asynchronously
        let task = URLSession.shared.dataTask(with: loginRequest.request,
                                              completionHandler: { (data, response, error) in
                                                
            if let httpStatus = response as? HTTPURLResponse {   // There is a response from the server
                print("Response Status Code : \(httpStatus.statusCode)")
                
                if httpStatus.statusCode == 200 {
                    print("Authentication response OK")
                    let responseStr = String(data: data!, encoding: String.Encoding.utf8)
                    let userId = Int(responseStr!)!
                    print("User ID = \(userId)")
                    
                    // Run in main queue
                    DispatchQueue.main.async { () -> Void in
                        // Store username, password and user ID in UserDefaults.standard
                        print("Storing user credentials")
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(password, forKey: "password")
                        UserDefaults.standard.set(userId, forKey: "uid")
                        
                        // Redirect to table view
                        print("Performing segue...")
                        self.performSegue(withIdentifier: "doLoginSegue", sender: self)
                    }
                } else {
                    print("Authentication response NOT ok: \(httpStatus.statusCode)")
                    
                    // Run UI updates on the main queue
                    DispatchQueue.main.async { () -> Void in
                        // Show error message
                        self.errorMessage.text = "Datos de acceso inválidos"
                        self.errorMessage.isHidden = false
                    }
                }
            }else{
                print("No response from server")
            }
        })
        task.resume()
    }
    
    func checkServerVersion(){
        let request = ServerVersionRequest()
        request.execute()
    }
    
    /*
    func attemptLoginOffline() -> Bool {
        if let upwd = users[usrnameTextField.text!] {           // Optional binding
            print("User \(usrnameTextField.text!) exists")
            if upwd == passwdTextField.text! {
                print ("Password OK")
                return true
            }else{
                print("Wrong password")
                
                return false
            }
        }else{
            print("User \(usrnameTextField.text!) does NOT exist")
            return false
        }
    }
    */
    
    @IBAction func nextActionKeyPressed(_ sender: UITextField) {
        print("Action Key Pressed - Next")
        // Set focus on the password field
        passwdTextField.becomeFirstResponder()
    }
    
    @IBAction func doneActionKeyPressed(_ sender: UITextField) {
        print("Action Key Pressed - Done")
        // Remove focus & hide keyboard
        passwdTextField.resignFirstResponder()
    }
    
    // Will prepare for the doLoginSegue indicating that the user
    // entered credentials in the login screen in order to access the app
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("LoginViewController preparing for segue")
        if segue.identifier == "doLoginSegue" {
            let destinationViewContoller = segue.destination as! CentralController
            destinationViewContoller.comingFromLoginScreen = true
        }
    }
    
    
}

