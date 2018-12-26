//
//  AccountActivity.swift
//  Atactic
//
//  Created by Jaime Lucea on 25/12/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class AccountActivityRequest : HTTPRequest {
    
    var request: URLRequest
    
    init(userId: Int, accountId: Int){
        let resourceURLString = NetworkConstants.APIServiceURL.AccountActivityResource + "?uid=\(userId)" + "&acc=\(accountId)"
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
