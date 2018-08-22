//
//  APIConnector.swift
//  Atactic
//
//  Created by Jaime on 23/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class VersionRequest {
    
    let versionResourceURL = URL(string: RequestConstants.APIServiceURL.ServerVersionResource)
    
    func execute(){
        
        // Define an async task
        let task = URLSession.shared.dataTask(with: versionResourceURL!) { (data, response, error) in
            
            if (error == nil) {
                print("No errors")
                
                // Assign the data from the response to a String
                let responseString = String(data: data!, encoding: String.Encoding.utf8)
                print(responseString! as Any)
                
            } else {
                print("ERROR: " + error.debugDescription)
            }
        }
        
        // Execute task
        task.resume()
    }
    
}

