//
//  ProfileRequest.swift
//  Atactic
//
//  Created by Jaime on 25/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class ProfileRequest : HTTPRequest {
    
    internal var request: URLRequest
    
    init(userId: Int){
        
        let resourceURLString = NetworkConstants.APIServiceURL.ProfileResource + "?uid=\(userId)"
        let myurl = URL(string: resourceURLString)!
        
        request = URLRequest(url: myurl)
        request.httpMethod = "GET"
    }
        
    func getRequest() -> URLRequest {
        return request
    }
    
    func getURLString() -> String {
        return self.request.url!.absoluteString
    }
    
}

