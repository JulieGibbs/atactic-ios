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
    var users : [String : String] = ["jlucea": "jame",
                                    "merivu": "meri",
                                    "hconget": "hector"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Atactic app loaded")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        print("Login button pressed")
        print("username: " + usrnameTextField.text!)
        print("password: " + passwdTextField.text!)
        errorMessage.isHidden = true
        errorMessage.text = ""
        
        if attemptLogin(){
            
            // Store username and password in UserDefaults.standard
            print("Storing user credentials")
            UserDefaults.standard.set(usrnameTextField.text!, forKey: "username")
            UserDefaults.standard.set(passwdTextField.text!, forKey: "password")
            
            // Redirect to table view
            self.performSegue(withIdentifier: "doLoginSegue", sender: self)
            
        }else{
            // Show error message
            errorMessage.text = "Datos de acceso inválidos"
            errorMessage.isHidden = false
            
        }
    }
    
    func attemptLogin() -> Bool {
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
    
    
}

