//
//  QuestTargetListDataHandler.swift
//  Atactic
//
//  Created by Jaime Lucea on 23/8/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation
import CoreLocation

class QuestTargetListDataHandler {
    
    // Reference to the view controller that will display the data
    let viewController : QuestTargetsSegmentController
    
    // Initializer
    init(viewController : QuestTargetsSegmentController) {
        self.viewController = viewController
        print("QuestTargetListDataHandler initialized")
    }
    
    //
    // Sends an HTTP request to the API in order to get the list of targets,
    //  decodes the returning JSON response and sends the data back to the View Controller
    //  by calling its setData() or setError() functions.
    //
    func getData() {
        print("QuestTargetListDataHandler - Get Data")
        
        // Recover user's ID and Participation ID
        let recoveredUserId : Int = UserDefaults.standard.integer(forKey: "uid")
        let participationId = self.viewController.participationId
        
        let httpRequest = CampaignTargetsRequest(userId: recoveredUserId, participationId: participationId)
        print("Request URL: " + httpRequest.getURLString())
        
        // Declare an asynchronous task that sends an HTTP request and handles the response
        let httpRequestTask = URLSession.shared.dataTask(with: httpRequest.getRequest()) { (data, response, error) in
            self.handleServerResponse(data: data, response: response, error: error)
        }
        // Execute asnychronous task, decoding the response and returning control to the ViewController
        httpRequestTask.resume()
    }
    
    private func handleServerResponse(data: Data?, response: URLResponse?, error: Error?) {
        
        // sleep(1)
        
        // Try cast to HTTP Response
        if let httpResponse = response as? HTTPURLResponse {
            
            print("QuestTargetListDataHandler - HTTP response received - \(httpResponse.statusCode)")
            if (httpResponse.statusCode == 200) {
                
                // Decode JSON response
                print("QuestTargetListDataHandler - Decoding JSON response")
                //print(String(data: data!, encoding: .utf8)!)
                //print()
                let decoder = JSONDecoder()
                let targets = try! decoder.decode([AccountStruct].self, from: data!)
                print("QuestTargetListDataHandler - Loaded \(targets.count) targets")
                
                // Run UI updates in the main queue
                DispatchQueue.main.async { () -> Void in
                    print("QuestTargetListDataHandler - Returning data to view controller")
                    self.viewController.displayData(targets: targets)
                }
                
            } else if (httpResponse.statusCode == 204) {
                print("QuestTargetListDataHandler - Empty list of targets received")
                DispatchQueue.main.async { () -> Void in
                    self.viewController.displayError(message: "No se han encontrado objetivos específicos para esta campaña")
                }
            } else {
                print("QuestTargetListDataHandler - Response error code \(httpResponse.statusCode)")
                DispatchQueue.main.async { () -> Void in
                    self.viewController.displayError(message: "No se han podido cargar los objetivos (error \(httpResponse.statusCode))")
                }
            }
        } else {
            print("TargetListDataHandler - No response from server")
            DispatchQueue.main.async { () -> Void in
                self.viewController.displayError(message: "No se ha podido conectar con el servidor")
            }
        }
    }
    

}



