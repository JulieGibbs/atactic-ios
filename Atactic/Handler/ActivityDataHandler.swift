//
//  ActivityRegisterDataHandler.swift
//  Atactic
//
//  Created by Jaime on 15/3/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import UIKit

class ActivityDataHandler {
    
    // Reference to the view controller that will display the data handled by this Handler
    let presenter : ActivityListPresenter
    
    init(dataPresenter : ActivityListPresenter) {
        self.presenter = dataPresenter
    }
    
    //
    // Sends an HTTP request to the API to get all the registered activity for the specified user,
    //  decodes the returning JSON response and sends back either the data or an error message
    //  to the Presenter.
    //
    func getActivities(userId: Int) {
        
        // Build the Http request to the TargetAccounts service
        let request = UserActivityRequest(userId: userId).getRequest()
        print(request.url as Any)
        
        // Define the HTTP request as a task to be executed asynchronously
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.handleServerResponse(data: data, response: response, error: error)
        }
        // Execute HTTP request
        task.resume()
    }
    
    //
    // Sends an HTTP request to the API to get all the registered activity for the specified user on the specified account,
    //  decodes the returning JSON response and sends back either the data or an error message
    //  to the Presenter.
    //
    func getActivities(userId: Int, accountId: Int) {
        
        // Build the Http request to the TargetAccounts service
        let request = AccountActivityRequest(userId: userId, accountId: accountId).getRequest()
        print(request.url as Any)
        
        // Define the HTTP request as a task to be executed asynchronously
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.handleServerResponse(data: data, response: response, error: error)
        }
        // Execute HTTP request
        task.resume()
    }
    
    
    private func handleServerResponse(data: Data?, response: URLResponse?, error: Error?){
        
        if let serverResponse = response as? HTTPURLResponse {
            print("ActivityDataHandler - Response received - \(serverResponse.statusCode)")
            if (serverResponse.statusCode == 200) {
                
                // DECODE JSON response
                print("ActivityDataHandler - Decoding data...")
                // print(String(data: data!, encoding: .utf8)!)
                // print()
                let decoder = JSONDecoder()
                let visits = try! decoder.decode([VisitStruct].self, from: data!)
                print("ActivityDataHandler - Decoded \(visits.count) visits from the server")
                
                // Run UI updates in the main queue
                DispatchQueue.main.async { () -> Void in
                    print("ActivityDataHandler - Returning data to presenter")
                    self.presenter.displayData(activityList: visits)
                }
            } else {
                DispatchQueue.main.async { () -> Void in
                    print("ActivityDataHandler - Error \(serverResponse.statusCode)")
                    self.presenter.displayMessage(message: "Se ha producido un error (\(serverResponse.statusCode)). Por favor, vuelva a intentarlo.")
                }
            }
        } else {
            DispatchQueue.main.async { () -> Void in
                print("ActivityDataHandler - No response from server")
                self.presenter.displayMessage(message: "No se ha podido conectar con el servidor. Compruebe su conexión.")
            }
        }
    }
    
}


