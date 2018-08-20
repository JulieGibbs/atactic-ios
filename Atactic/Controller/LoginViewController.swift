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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    var authenticationHandler : LoginHandler?
    
    /*
    override var prefersStatusBarHidden: Bool {
        print("LoginView prefers status bar hidden")
        return true
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login View Controller loaded")
        
        authenticationHandler = LoginHandler(view: self)
        
        // In case there is a navigation controller with a top bar, hide it.
        self.navigationController?.navigationBar.isHidden = true
    }

    /*
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("Login View will disappear")
        // self.navigationController?.navigationBar.isHidden = false
        // self.tabBarController?.tabBar.isHidden = false
    } */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        print("Login button pressed")
        self.showLoadingIndicator()
        
        // Recover user credential from UI Views
        let usr = usrnameTextField.text!
        let pwd = passwdTextField.text!
        print("username: " + usr)
        // print("password: " + pwd)
        
        hideErrorMessage()
        
        // Execute login logic
        authenticationHandler?.attemptLogin(username: usr, password: pwd)
    }
    
    func enterApp() {
        print("Performing segue...")
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

