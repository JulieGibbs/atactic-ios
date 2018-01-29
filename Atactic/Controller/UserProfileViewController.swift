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

        print("User Profile View Controler loaded")
        
        // Request profile data to the server and fill UI views
        loadUserData()
    }
    
    
    func loadUserData() {
        
        let requestForProfileData = ProfileRequest(userId: 57)
        
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutSegue" {
            print("Loging out - Removing stored credentials")
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "password")
        }
    }

}
