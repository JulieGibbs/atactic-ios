//
//  APIConnector.swift
//  Atactic
//
//  Created by Jaime on 23/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class ServerVersionRequest : HTTPRequest {
    
    var request : URLRequest
    
    init() {
        let versionResourceURL = URL(string: NetworkConstants.APIServiceURL.ServerVersionResource)
        request = URLRequest(url: versionResourceURL!)
        request.httpMethod = "GET"
    }
    
    func getRequest() -> URLRequest {
        return request
    }
    
    func getURLString() -> String {
        return self.request.url!.absoluteString
    }
    
//    func execute(){
//
//        // Define an async task
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            if (error == nil) {
//                print("No errors")
//
//                // Assign the data from the response to a String
//                let responseString = String(data: data!, encoding: String.Encoding.utf8)
//                print(responseString! as Any)
//
//            } else {
//                print("ERROR: " + error.debugDescription)
//            }
//        }
//
//        // Execute task
//        task.resume()
//    }
    
}
