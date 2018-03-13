//
//  RequestFactory.swift
//  Atactic
//
//  Created by Jaime on 29/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class RequestFactory {
        
    static func buildLoginRequest(user: String, pass: String) -> URLRequest {
    
        let resourceURL = URL(string: NetworkConstants.AtacticAPIResourceURL.AuthenticationResource)
        var request = URLRequest(url: resourceURL!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let paramsStr = "username" + "=" + user + "&" + "password" + "=" + pass
        request.httpBody = paramsStr.data(using: .utf8)
        return request
    }
    
    
    static func buildTargetAccountsRequest(userId: Int) -> URLRequest {
        
        let urlStr = NetworkConstants.AtacticAPIResourceURL.TargetAccountsForUser + "?uid=\(userId)"
        var request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "GET"
        return request
    }
    
    
}





