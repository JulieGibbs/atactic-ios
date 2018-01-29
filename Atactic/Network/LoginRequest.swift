//
//  LoginRequest.swift
//  Atactic
//
//  Created by Jaime on 23/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class LoginRequest {
    
    let resourceURL = URL(string: AtacticServers.DevelopmentAPIBaseURL + AtacticAPIResources.AuthenticationResource)
    var request: URLRequest
    
    init(user: String, pass: String) {
        
        request = URLRequest(url: resourceURL!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let paramsStr = "username" + "=" + user + "&" + "password" + "=" + pass
        request.httpBody = paramsStr.data(using: .utf8)
    }
    
}
