//
//  OffTargetAccountsRequest.swift
//  Atactic
//
//  Created by Jaime on 29/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class AccountsRequest {
    
    var resourceURLString = RequestConstants.APIServiceURL.AccountsResource
    
    var request: URLRequest
    
    init(userId: Int, nonTargetOnly: Bool){
        
        resourceURLString += "?uid=\(userId)"
        if nonTargetOnly {
            resourceURLString += "&offtgtonly=true"
        } else {
            resourceURLString += "&offtgtonly=false"
        }
        
        let myurl = URL(string: resourceURLString)!
        request = URLRequest(url: myurl)
        request.httpMethod = "GET"
    }
    
    func getRequest() -> URLRequest {
        return request
    }
    
}

