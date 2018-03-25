//
//  TargetListDataHandler.swift
//  Atactic
//
//  Created by Jaime on 21/3/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation
import CoreLocation

class TargetListDataHandler {
    
    // Reference to the view controller that will display the data
    let viewController : TargetListViewController
    
    // Initializer
    init(viewController : TargetListViewController) {
        self.viewController = viewController
        print("TargetListDataHandler initialized")
    }

    //
    // Sends an HTTP request to the API in order to get the list of targets for the current user,
    //  decodes the returning JSON response and sends the data back to the View Controller
    //  by calling its setData() or setError() functions.
    //
    func getData() {

        // Recover user's ID
        let recoveredUserId : Int = UserDefaults.standard.integer(forKey: "uid")
        
        // Get user's last knowns location
        print("TargetListDataHandler - Requesting user location to LocationController")
        
        // Build the Http request to the TargetAccounts service
        var request : PriorityTargetsRequest
        if let location = LocationController.global.getMostRecentLocation() {
            request = PriorityTargetsRequest(userId: recoveredUserId,
                                                 userLocationLatitude: location.coordinate.latitude,
                                                 userLocationLongitude: location.coordinate.longitude)
        } else {
            print("TargetListDataHandlar - User location unknown, requesting targets without location parameters")
            request = PriorityTargetsRequest(userId: recoveredUserId)
        }
        // print("TargetListDataHandler - Location: \(location?.coordinate)")

        print("Request ready: " + request.getURLString())
        
        let task = URLSession.shared.dataTask(with: request.getRequest()) { (data, response, error) in
            
            if let serverResponse = response as? HTTPURLResponse {
                print("TargetListDataHandler - HTTP response received - \(serverResponse.statusCode)")
                if (serverResponse.statusCode == 200) {
                    // DECODE JSON response
                    print("TargetListDataHandler - Decoding JSON response")
                    //print(String(data: data!, encoding: .utf8)!)
                    //print()
                    let decoder = JSONDecoder()
                    let targetList = try! decoder.decode([ParticipationTargetStruct].self, from: data!)
                    print("TargetListDataHandler - Loaded \(targetList.count) targets from the server")
                    
                    // Run UI updates in the main queue
                    DispatchQueue.main.async { () -> Void in
                        print("TargetListDataHandler - Returning data to view controller")
                        self.viewController.setData(targets: targetList)
                    }
                } else {
                    print("TargetListDataHandler - Response error code \(serverResponse.statusCode)")
                    // TODO SEND ERROR TO VIEW CONTROLLER
                }
            } else {
                print("TargetListDataHandler - No response from server")
                // TODO SEND ERROR TO VIEW CONTROLLER
            }
        }
        task.resume()
    }
    
}



