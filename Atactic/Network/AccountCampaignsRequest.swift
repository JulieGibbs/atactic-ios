//
//  AccountCampaignsRequest.swift
//  Atactic
//
//  Created by Jaime Lucea on 01/10/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class AccountCampaignsRequest : HTTPRequest {
    
    var request : URLRequest
    
    // Request parameters
    let userIdParam = "uid"
    let accountIdParam = "accid"
    
    init(userId: Int, accountId: Int) {
        let urlStr = NetworkConstants.APIServiceURL.AccountCampaignsResource + "?"
            + userIdParam + "=\(userId)" + "&"
            + accountIdParam + "=\(accountId)"
        
        request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "GET"
    }
    
    func getRequest() -> URLRequest {
        return request
    }
    
    func getURLString() -> String {
        return self.request.url!.absoluteString
    }
    
    
}


