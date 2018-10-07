//
//  UserProfileViewController.swift
//  Atactic
//
//  Created by Jaime on 1/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var scoreIndicator: UILabel!
    @IBOutlet var rankIndicator: UILabel!
    
    @IBOutlet var activityRegisterMenuLine: UIView!
    @IBOutlet var changePasswordMenuLine: UIView!
    @IBOutlet var logoutMenuLine: UIView!
    
    struct Profile : Codable {
        let userId : Int
        let email : String
        let firstName : String
        let lastName : String
        let position : String
        let score : Int
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("User Profile View Controler did appear")
        
        // Request profile data to the server and fill UI views
        loadUserData()
        
        // Setup navigation controls
        setupMenuActions()
    }
    
    @objc func goToActivityRegister() {
        print("Moving to activity register")
        performSegue(withIdentifier: "showActivityRegisterSegue", sender: self)
    }
    
    @objc func goToPasswordChangeForm() {
        print("Will move to password change form")
        
        // Segue 
        performSegue(withIdentifier: "showPasswordChangeSegue", sender: self)
    }
    
    @objc func logout() {
        print("Signing out - Removing stored credentials")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    //
    // Declare gesture recognizers and add them to the corresponding menu views
    //
    func setupMenuActions() {
        
        // Declare gesture recognizers
        let toActivityRegisterGesture = UITapGestureRecognizer(target: self, action: #selector (self.goToActivityRegister))
        let toChangePasswordGesture = UITapGestureRecognizer(target: self, action: #selector (self.goToPasswordChangeForm))
        let logoutGesture = UITapGestureRecognizer(target: self, action: #selector (self.logout))
        
        // Add gesture recognizers to view elements
        activityRegisterMenuLine.addGestureRecognizer(toActivityRegisterGesture)
        changePasswordMenuLine.addGestureRecognizer(toChangePasswordGesture)
        logoutMenuLine.addGestureRecognizer(logoutGesture)
    }
    
    
    func loadUserData() {
        // Recover user's ID from UserDefaults
        let recoveredUserId = UserDefaults.standard.integer(forKey: "uid")
        
        let requestForProfileData = ProfileRequest(userId: recoveredUserId)
        
        // Asynchronous request for user data
        let task = URLSession.shared.dataTask(with: requestForProfileData.request,
                                              completionHandler: { (data, response, error) in
                                                
            if let httpStatus = response as? HTTPURLResponse {              // There is a response from the server
                print("Response Status Code : \(httpStatus.statusCode)")
                if httpStatus.statusCode == 200 {
                    
                    let decoder = JSONDecoder()
                    let profileData = try! decoder.decode(Profile.self, from: data!)
                    
                    // Perform UI updates in the main queue
                    DispatchQueue.main.async { () -> Void in
                        self.fullNameLabel.text = profileData.firstName + " " + profileData.lastName
                        self.positionLabel.text = profileData.position
                        self.scoreIndicator.text = "\(profileData.score)"
                    }
                }
            }
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutSegue" {
            logout()
        }
    } */

}
