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
                print("MapDataHandler - Account Map received \(serverResponse.statusCode)")
                if (serverResponse.statusCode == 200) {
                    
                    // DECODE JSON response
                    print("MapDataHandler - Decoding Account Map from JSON response")
                    // print(String(data: data!, encoding: .utf8)!)
                    // print()
                    let decoder = JSONDecoder()
                    let accountMap = try! decoder.decode(AccountMap.self, from: data!)
                    print("MapDataHandler - Loaded \(accountMap.targets.count) targets and \(accountMap.accounts.count) accounts")
                                        
                    // Run UI updates in the main queue
                    DispatchQueue.main.async { () -> Void in
                        print("MapDataHandler: returning data to view controller")
                        self.mapViewController.displayData(highPriorityMarkers: accountMap.targets, lowPriorityMarkers:accountMap.accounts)
                    }
                } else {
                    print("MapDataHandler - Error code \(serverResponse.statusCode)")
                }
            } else {
                print("MapDataHandler - No response from server")
            }
        }
        
        // Execute HTTP request
        task.resume()
    }
    
    
    func generateRoute() {
        
        // Recover user's ID from UserDefaults
        let recoveredUserId = UserDefaults.standard.integer(forKey: "uid")
        
        // Get user's last known location
        print("MapDataHandler - Requesting user location to LocationController")
        if let location = LocationController.global.getMostRecentLocation() {
            
            
            // Build the Http request
            let request = RouteRequest(userId: recoveredUserId, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, waypoints: 4).getRequest()

            // Define the HTTP request as a task to be executed asynchronously
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let serverResponse = response as? HTTPURLResponse {
                    print("MapDataHandler - Received reponse from Route Service - \(serverResponse.statusCode)")
                    if (serverResponse.statusCode == 200) {
                        
                        // DECODE JSON response
                        print("MapDataHandler - Decoding Route from JSON response")
                        
                        print(String(data: data!, encoding: .utf8)!)
                        print()
                        
                        let decoder = JSONDecoder()
                        let route = try! decoder.decode([AccountStruct].self, from: data!)
                        print("MapDataHandler - Route contains \(route.count) accounts")
                        
                        // Run UI updates in the main queue
                        DispatchQueue.main.async { () -> Void in
                            print("MapDataHandler - Returning data to view controller")
                            self.mapViewController.displayRoute(origin: location, route: route)
                        }
                    } else {
                        print("MapDataHandler - Error code \(serverResponse.statusCode)")
                        // TODO mapViewController.displayError
                    }
                } else {
                    print("MapDataHandler - No response from server")
                    // TODO mapViewController.displayError
                }
            }
            
            // Execute HTTP request
            task.resume()
            
        } else {
            print("MapDataHandler - User location unavailable: Can't calculate route")
            // TODO Show Error
        }
    }
    
    
}
