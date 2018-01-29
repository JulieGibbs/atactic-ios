//
//  APIConnector.swift
//  Atactic
//
//  Created by Jaime on 23/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class ServerVersionRequest {
    
    let versionResourceURL = URL(string: "http://localhost:8080/mobile/rsc/version")
    
    func execute(){
        
        let task = URLSession.shared.dataTask(with: versionResourceURL!) { (data, response, error) in
            
            if (error == nil) {
                print("No errors")
                
                let responseString = String(data: data!, encoding: String.Encoding.utf8)
                print(responseString! as Any)
                
            } else {
                print("ERROR: " + error.debugDescription)
            }
        }
        
        task.resume()
    }
    
}

