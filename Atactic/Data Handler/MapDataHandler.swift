//
//  MapDataHandler.swift
//  Atactic
//
//  Created by Jaime Lucea on 17/8/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class MapDataHandler {
    
    let mapViewController : GoogleMapsViewController
    
    init(viewController : GoogleMapsViewController) {
        self.mapViewController = viewController
    }
    
    func getData() {
        
        // Recover user's ID from UserDefaults
        let recoveredUserId = UserDefaults.standard.integer(forKey: "uid")
        
        // Build the Http request to the Accounts service
        let request = AccountMapRequest(userId: recoveredUserId).getRequest()
        
        // Define the HTTP request as a task to be executed asynchronously
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let serverResponse = response as? HTTPURLResponse {
                print("Account Map received - \(serverResponse.statusCode)")
                if (serverResponse.statusCode == 200) {
                    
                    // DECODE JSON response
                    print("Decoding Account Map from JSON response")
                    // print(String(data: data!, encoding: .utf8)!)
                    // print()
                    let decoder = JSONDecoder()
                    let accountMap = try! decoder.decode(AccountMap.self, from: data!)
                    print("MapDataHandler - Loaded \(accountMap.targets.count) targets and \(accountMap.accounts.count) accounts")
                                        
                    // Run UI updates in the main queue
                    DispatchQueue.main.async { () -> Void in
                        print("MapDataHandler: returning data to view controller")
                        self.mapViewController.setData(highPriorityMarkers: accountMap.targets, lowPriorityMarkers:accountMap.accounts)
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
