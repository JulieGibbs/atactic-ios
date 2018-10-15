//
//  ConfigurationHandler.swift
//  Atactic
//
//  Created by Jaime Lucea on 14/10/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class ConfigurationHandler {
    
    
    func getConfiguration(userId : Int) {
        
        // Build HTTP request
        let request = TenantConfigurationRequest(userId: userId)
        print(request.getURLString())
        
        let httpRequestTask = URLSession.shared.dataTask(with: request.getRequest()) { (data, response, error) in
            self.handleResponse(data: data, response: response, error: error)
        }
        
        httpRequestTask.resume()
    }
    
    
    private func handleResponse(data: Data?, response : URLResponse?, error: Error?) {
        
        // Try cast to HTTP Response
        if let httpResponse = response as? HTTPURLResponse {
            
            print("ConfigurationHandler - HTTP response received - \(httpResponse.statusCode)")
            if (httpResponse.statusCode == 200) {
                
                // Print raw JSON
                // print(String(data: data!, encoding: .utf8)!)
                // print()
                
                // DECODE JSON
                let decoder = JSONDecoder()
                let configuration = try! decoder.decode(Configuration.self, from: data!)
                
                // print("Configuration properties: ")
                // print("Accounts literal: \(configuration.accountsLiteral)")
                // print("Check-in Enabled: \(configuration.checkInEnabled)")
                
                // Store Configuration in UserDefaults, running in Main Queue
                DispatchQueue.main.async { () -> Void in
                    
                    if (configuration.checkInEnabled){
                        print("Storing CHECK-IN ENABLED = TRUE")
                    } else {
                        print("Storing CHECK-IN ENABLED = FALSE")
                    }
                    
                    UserDefaults.standard.set(configuration.checkInEnabled, forKey: "checkInEnabled")
                    
                }
                
            } else {
                print("ConfigurationHandler - Response error code \(httpResponse.statusCode)")
                // self.viewController.displayError(message: "Se ha producido un error \(httpResponse.statusCode). Por favor, reinicie la aplicación")
            }
        } else {
            print("ConfigurationHandler - No response from server")
            // self.viewController.displayError(message: "No se ha podido conectar con el servidor")
        }
    }
    
    
}
