//
//  LoginRequest.swift
//  Atactic
//
//  Created by Jaime on 23/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

//
// Class containing a request object that can interact with the authentication resource
// from ATACTIC's API
//
class LoginRequest : HTTPRequest {
    
    // URL for the Authentication Service in the ATACTIC API
    let resourceURL = URL(string: NetworkConstants.APIServiceURL.AuthenticationResource)
    
    // URL Request object
    var request: URLRequest

    //
    // The class constructor initializes the URL Request object
    //
    init(user: String, pass: String) {
        
        request = URLRequest(url: resourceURL!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let paramsStr = "username" + "=" + user + "&" + "password" + "=" + pass
        request.httpBody = paramsStr.data(using: .utf8)
    }
    
    func getRequest() -> URLRequest {
        return request
    }
    
    func getURLString() -> String {
        return self.request.url!.absoluteString
    }
    
}
