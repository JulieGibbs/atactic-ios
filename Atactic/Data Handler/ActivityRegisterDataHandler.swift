//
//  ActivityRegisterDataHandler.swift
//  Atactic
//
//  Created by Jaime on 15/3/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import UIKit

class ActivityRegisterDataHandler {
    
    // Reference to the view controller that will display the data handled by this Handler
    let viewController : ActivityRegisterViewController
    
    init(viewController : ActivityRegisterViewController) {
        self.viewController = viewController
    }
    
    //
    // Sends an HTTP request to the API to get the registered activity for the current user,
    //  decodes the returning JSON response and sends the data back to the View Controller,
    //  or sends back an error message.
    //
    func getData() {
        
        // Recover user's ID from UserDefaults
        let recoveredUserId = UserDefaults.standard.integer(forKey: "uid")
        
        // Build the Http request to the TargetAccounts service
        let request = ActivityRegisterRequest(userId: recoveredUserId).getRequest()
        
        // Define the HTTP request as a task to be executed asynchronously
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let serverResponse = response as? HTTPURLResponse {
                print("Check-in List response received - \(serverResponse.statusCode)")
                if (serverResponse.statusCode == 200) {
                    // DECODE JSON response
                    print("Decoding list of activities from JSON response")
                    // print(String(data: data!, encoding: .utf8)!)
                    // print()
                    let decoder = JSONDecoder()
                    let visits = try! decoder.decode([VisitStruct].self, from: data!)
                    print("ActivityRegisterDataHandler - Loaded \(visits.count) visits from the server")
                    
                    // Run UI updates in the main queue
                    DispatchQueue.main.async { () -> Void in
                        print("ActivityRegisterDataHandler: returning data to view controller")
                        self.viewController.setData(listOfActivities: visits)
                    }
                } else {
                    print("Error code \(serverResponse.statusCode)")
                }
            } else {
                print("No response from server")
            }
        }
        
        // Execute HTTP request
        task.resume()
    }
    
}


