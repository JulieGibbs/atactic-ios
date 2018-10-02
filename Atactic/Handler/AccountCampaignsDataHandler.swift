//
//  AccountCampaignsDataHandler.swift
//  Atactic
//
//  Created by Jaime Lucea on 01/10/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation
import UIKit

class AccountCampaignsDataHandler {
    
    let viewController : AccountCampaignsSegmentController
    
    init(viewController: AccountCampaignsSegmentController){
        self.viewController = viewController
    }
    
    
    func getData(accountId: Int) {
        
        // Recover user's ID
        let recoveredUserId : Int = UserDefaults.standard.integer(forKey: "uid")
        
        // Build HTTP request
        let request = AccountCampaignsRequest(userId: recoveredUserId, accountId: accountId)
        print(request.getURLString())
        
        // Declare an asynchronous task that sends an HTTP request and handles the response from the server
        let httpRequestTask = URLSession.shared.dataTask(with: request.getRequest()) { (data, response, error) in
            self.handleResponse(data: data, response: response, error: error)
        }
        
        // Execute asnychronous task, decoding the response and returning control to the ViewController
        httpRequestTask.resume()
    }
    
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
        
        // Try cast to HTTP Response
        if let httpResponse = response as? HTTPURLResponse {
            
            print("AccountCampaignsDataHandler - HTTP response received - \(httpResponse.statusCode)")
            if (httpResponse.statusCode == 200) {
                
                // print(String(data: data!, encoding: .utf8)!)
                // print()
                
                // Decode JSON response
                let campaignList = decode(data: data!)
                
                // Run UI updates in the main queue
                DispatchQueue.main.async { () -> Void in
                    if (campaignList.isEmpty) {
                        print("AccountCampaignsDataHandler - Empty list of participations received")
                        // self.viewController.displayError(message: "No se han encontrado objetivos prioritarios")
                    } else {
                        print("AccountCampaignsDataHandler - Returning data to view controller")
                        self.viewController.displayData(participations: campaignList)
                    }
                }
            } else {
                print("AccountCampaignsDataHandler - Response error code \(httpResponse.statusCode)")
                // self.viewController.displayError(message: "Se ha producido un error \(httpResponse.statusCode). Por favor, reinicie la aplicación")
            }
        } else {
            print("AccountCampaignsDataHandler - No response from server")
            // self.viewController.displayError(message: "No se ha podido conectar con el servidor")
        }
    }
    
    //
    // DECODE JSON response
    //
    private func decode(data: Data) -> [Participation] {
        
        print("AccountCampaignsDataHandler - Decoding JSON response")
        
        let decoder = JSONDecoder()
        let participationList = try! decoder.decode([Participation].self, from: data)
        
        print("AccountCampaignsDataHandler - Decoded \(participationList.count) participations")
        
        return participationList
    }
    
    
}

