//
//  AccountMapRequest.swift
//  Atactic
//
//  Created by Jaime Lucea on 17/8/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class AccountMapRequest {
    
    var resourceURLString = NetworkConstants.APIServiceURL.AccountsResource + "/map"
    
    var request: URLRequest
    
    init(userId: Int){
        
        resourceURLString += "?uid=\(userId)"
        let myurl = URL(string: resourceURLString)!
        
        request = URLRequest(url: myurl)
        request.httpMethod = "GET"
    }
    
    func getRequest() -> URLRequest {
        return request
    }
    
}
