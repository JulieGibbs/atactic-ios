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
        
        let httpRequest = buildRequest(userId: recoveredUserId)
        
        // Declare an asynchronous task that sends an HTTP request and handles the response
        let httpRequestTask = URLSession.shared.dataTask(with: httpRequest.getRequest()) { (data, response, error) in
            self.handleServerResponse(data: data, response: response, error: error)
        }
        // Execute asnychronous task, decoding the response and returning control to the ViewController
        httpRequestTask.resume()
    }
    
    //
    // Build the Http request to the TargetAccounts service
    //
    private func buildRequest(userId: Int) -> PriorityTargetsRequest {

        var request : PriorityTargetsRequest
        
        // Get user's last known location
        print("TargetListDataHandler - Requesting user location to LocationController")
        if let location = LocationController.global.getMostRecentLocation() {
            request = PriorityTargetsRequest(userId: userId,
                                             userLocationLatitude: location.coordinate.latitude,
                                             userLocationLongitude: location.coordinate.longitude)
        } else {
            print("TargetListDataHandlar - User location unknown, requesting targets without location parameters")
            request = PriorityTargetsRequest(userId: userId)
        }
        // print("TargetListDataHandler - Location: \(location?.coordinate)")
        
        print("Request URL: " + request.getURLString())
        
        return request
    }
    
    
    private func handleServerResponse(data: Data?, response: URLResponse?, error: Error?) {
        
        // Try cast to HTTP Response
        if let httpResponse = response as? HTTPURLResponse {
        
            print("TargetListDataHandler - HTTP response received - \(httpResponse.statusCode)")
            if (httpResponse.statusCode == 200) {
                
                // Decode JSON response
                let targetMap = decode(data: data!)
                
                // Transform the TargetMap structure type into an Array of Target objects
                var targets : [Target] = transform(targetMap: targetMap)
                
                // Calculate distance to each target account
                if let currentLocation = LocationController.global.getMostRecentLocation() {
                    targets = setDistances(location: currentLocation, list: targets)
                    
                    // Sort by distance
                    targets = targets.sorted(by: {$0.account.distance < $1.account.distance})
                }
                
                // Run UI updates in the main queue
                DispatchQueue.main.async { () -> Void in
                    if (targets.isEmpty) {
                        print("TargetListDataHandler - Empty list of targets received")
                        self.viewController.displayError(message: "No se han encontrado objetivos prioritarios")
                    } else {
                        print("TargetListDataHandler - Returning data to view controller")
                        self.viewController.displayData(targets: targets)
                    }
                }
            } else {
                print("TargetListDataHandler - Response error code \(httpResponse.statusCode)")
                self.viewController.displayError(message: "Se ha producido un error \(httpResponse.statusCode). Por favor, reinicie la aplicación")
            }
        } else {
            print("TargetListDataHandler - No response from server")
            self.viewController.displayError(message: "No se ha podido conectar con el servidor")
        }
    }
    
    
    private func setDistances(location: CLLocation, list : [Target]) -> [Target] {
        var newList : [Target] = []
        for tgt in list {
            var ntgt = tgt
            let accountLocation = CLLocation(latitude: tgt.account.latitude, longitude: tgt.account.longitude)
            ntgt.account.distance = Float(location.distance(from: accountLocation))
            newList.append(ntgt)
        }
        return newList
    }
    
    //
    // Transforms the TargetMap structure, which is 
    //
    private func transform(targetMap : TargetMap) -> [Target] {

        var targetList : [Target] = []
        
        for pt in targetMap.map {
            // pt points to a participation that targets certain accounts
            
            for tgt in pt.targets {
                var target = Target(acc: tgt)
                let isRepeated = targetList.contains(where: { $0.account.id == target.account.id })
                if (isRepeated){
                    // If target is already found in targetList
                    // Recalculate lead score and update target in the list
                    let targetIndex = targetList.index(where: { $0.account.id == target.account.id })!
                    var target : Target = targetList[targetIndex]
                    target.score = target.score + pt.stepScore
                    targetList.remove(at: targetIndex)
                    targetList.append(target)
                } else {
                    // Add new target
                    target.score = pt.stepScore
                    targetList.append(target)
                }
            }
        }
        return targetList
    }
    
    //
    // DECODE JSON response
    //
    private func decode(data: Data) -> TargetMap {
        
        print("TargetListDataHandler - Decoding JSON response")
        //print(String(data: data!, encoding: .utf8)!)
        //print()
        let decoder = JSONDecoder()
        let targetList = try! decoder.decode(TargetMap.self, from: data)
        
        // print("TargetListDataHandler - Loaded \(targetList.count) targets from the server")
        
        return targetList
    }
    
}



