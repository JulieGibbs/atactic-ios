//
//  CheckInHandler.swift
//  Atactic
//
//  Created by Jaime Lucea on 15/10/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation


class CheckInHandler {
    
    let viewController : CheckInViewController
    
    init(view: CheckInViewController) {
        self.viewController = view
    }
    
    func getAccountsEligibleForCheckIn() {
        
        // Recover user's ID
        let recoveredUserId : Int = UserDefaults.standard.integer(forKey: "uid")
        
        // Get current location
        if let location = LocationController.global.getMostRecentLocation() {
            
            // Instantiate HTTP Request for the Nearby Accounts API Service
            let request = NearbyAccountsRequest(userId: recoveredUserId,
                                            userLocationLatitude: location.coordinate.latitude,
                                            userLocationLongitude: location.coordinate.longitude)
            
            print("CheckInHandler - Request ready - \(request.getURLString())")
            
            // Declare an asynchronous task that sends the HTTP request and handles the response
            let httpRequestTask = URLSession.shared.dataTask(with: request.getRequest()) { (data, response, error) in
                self.handleNearbyAccountsResponse(data: data, response: response, error: error)
            }
            
            // Execute task
            httpRequestTask.resume()
            
        }else{
            print("CheckInHandler - Location unknown. Unable to build request")
        }
    }
    
    // Manage response:
    // Decode
    // send list of accounts to the view
    private func handleNearbyAccountsResponse(data: Data?, response: URLResponse?, error: Error?) {
        
        // Try cast to HTTP Response
        if let httpResponse = response as? HTTPURLResponse {
            
            print("CheckInHandler - HTTP response received - \(httpResponse.statusCode)")
            if (httpResponse.statusCode == 200) {
                
                // Print raw JSON
//                print()
//                print("CheckInHandler - Server response: ")
//                print(String(data: data!, encoding: .utf8)!)
                
                // Decode JSON into [AccountStruct]
                let decoder = JSONDecoder()
                let eligibleAccounts = try! decoder.decode([AccountStruct].self, from: data!)
                
                // print()
                print("CheckInHandler - Decoded \(eligibleAccounts.count) check-in eligible accounts")
                
                // Run UI updates in the main queue
                DispatchQueue.main.async { () -> Void in
                    self.viewController.setEligibleAccounts(accounts: eligibleAccounts)
                }
            } else {
                // Error while loading nearby accounts
            }
            
        } else {
            print("CheckInHandler - No response from server")
            // self.viewController.displayError(message: "No se ha podido conectar con el servidor")
        }
    }
    
    
    //
    //
    //
    func doCheckIn(visitedAccountId: Int, meetingNotes: String) {
    
        // Recover user's ID
        let recoveredUserId : Int = UserDefaults.standard.integer(forKey: "uid")
        
        // Get current location
        if let location = LocationController.global.getMostRecentLocation() {
        
            // Build HTTP check-in request
            let request = CheckInRequest(userId: recoveredUserId, accountId: visitedAccountId, comments: meetingNotes,
                                         latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            print("CheckInHandler - Check-in request ready - \(request.getURLString())")
            
            // Declare an asynchronous task that sends the HTTP request and handles the response
            let httpRequestTask = URLSession.shared.dataTask(with: request.getRequest()) { (data, response, error) in
                self.handleCheckInResponse(data: data, response: response, error: error)
            }
            
            // Execute asynchronously
            httpRequestTask.resume()
        
        } else {
            print("CheckInHandler - Location unknown. Cannot do check-in")
        }
    }
    
    //
    //
    //
    func handleCheckInResponse(data: Data?, response: URLResponse?, error: Error?){
        
        // Try cast to HTTP Response
        if let httpResponse = response as? HTTPURLResponse {
            
            print("CheckInHandler - HTTP response received - \(httpResponse.statusCode)")
            if (httpResponse.statusCode == 200) {
                
                print("CheckInHandler - Check-in saved")
                
                // Run UI updates in the main queue
                DispatchQueue.main.async { () -> Void in
                    self.viewController.checkInOk()
                }
                
            } else {
                print("CheckInHandler - Check-in error")
                // Check-in error
            }
        } else {
            print("CheckInHandler - No response from server")
            // self.viewController.displayError(message: "No se ha podido conectar con el servidor")
        }
    }
    
    
}
