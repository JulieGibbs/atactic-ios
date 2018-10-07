//
//  PasswordChangeRequest.swift
//  Atactic
//
//  Created by Jaime Lucea on 03/10/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class PasswordChangeRequest : HTTPRequest {
    
    internal var request: URLRequest
    
    // Parameters
    internal let userIdParam = "uid"
    internal let newPassParam = "npwd"
    
    internal let userId : Int
    internal let newPassword : String
    
    // Initializer
    init(userId: Int, newPass: String){
        self.userId = userId
        self.newPassword = newPass
        
        // Build URL
        let requestURL = URL(string: NetworkConstants.APIServiceURL.PasswordResource + "?"
            + "\(userIdParam)=\(userId)"
            + "&\(newPassParam)=\(newPassword)")!
        
        request = URLRequest(url: requestURL)
        
        // This is a POST request
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
    
    func getRequest() -> URLRequest {
        return request
    }
    
    func getURLString() -> String {
        return self.request.url!.absoluteString
    }
    
}
