//
//  ViewController.swift
//  Atactic
//
//  Created by Jaime on 27/12/17.
//  Copyright © 2017 ATACTIC. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController, AuthenticationController {

    @IBOutlet var usrnameTextField: UITextField!
    @IBOutlet var passwdTextField: UITextField!
    @IBOutlet var errorMessage: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    var authenticationHandler : LoginHandler?
    
    //
    // Instantiate LoginHandler when the view is loaded
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController - Did load")
        
        authenticationHandler = LoginHandler(view: self)
        
        // In case there is a navigation controller with a top bar, hide it.
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        print("LoginViewController - Login button pressed")
        self.showLoadingIndicator()
        
        // Recover user credential from UI Views
        let usr = usrnameTextField.text!
        let pwd = passwdTextField.text!
        // print("username: " + usr)
        
        if (!errorMessage.isHidden) { hideErrorMessage() }
        
        // Execute login logic
        authenticationHandler?.attemptLogin(username: usr, password: pwd)
    }
    
    func onAuthenticationSucess(token: String) {
        let userId = Int(token)!
        loadConfiguration(userId: userId)
        storeUserCredentials(token: token)
        enterApp()
    }
    
    func onAuthenticationFailure(message: String?) {
        displayErrorMessage(message: message!)
    }
    
    func loadConfiguration(userId: Int){
        // Get Configuration
        print("LoginViewController - Requesting configuration for user \(userId)")
        let configHandler = ConfigurationHandler()
        configHandler.getConfiguration(userId: userId)
    }
    
    func storeUserCredentials(token: String){
        // Store username, password and user ID in UserDefaults.standard
        print("LoginViewController - Storing user credentials")
        UserDefaults.standard.set(self.usrnameTextField.text, forKey: "username")
        UserDefaults.standard.set(self.passwdTextField.text, forKey: "password")
        UserDefaults.standard.set(token, forKey: "uid")
    }
    
    func enterApp() {
        print("LoginViewController - Entering app...")
        self.performSegue(withIdentifier: "doLoginSegue", sender: self)
        hideLoadingIndicator()
    }
    
    func displayErrorMessage(message: String) {
        self.errorMessage.text = message
        self.errorMessage.isHidden = false
        hideLoadingIndicator()
    }
    
    private func hideErrorMessage(){
        errorMessage.isHidden = true
        errorMessage.text = ""
    }
    
    private func showLoadingIndicator(){
        loginButton.isEnabled = false
        self.activityIndicator.isHidden = false
        self.activityIndicator!.startAnimating()
    }
    
    private func hideLoadingIndicator(){
        loginButton.isEnabled = true
        self.activityIndicator.isHidden = true
    }
    
    @IBAction func nextActionKeyPressed(_ sender: UITextField) {
        // print("Action Key Pressed - Next")
        // Set focus on the password field
        passwdTextField.becomeFirstResponder()
    }
    
    @IBAction func doneActionKeyPressed(_ sender: UITextField) {
        // print("Action Key Pressed - Done")
        // Remove focus & hide keyboard
        passwdTextField.resignFirstResponder()
    }
    
    
}

