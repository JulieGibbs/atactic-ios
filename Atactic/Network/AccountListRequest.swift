//
//  AccountListRequest.swift
//  Atactic
//
//  Created by Jaime Lucea on 08/12/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class AccountListRequest : HTTPRequest {
    
    var request: URLRequest
    
    let userIdParam = "uid"
    
    init(userId: Int){
        let urlStr = NetworkConstants.APIServiceURL.AccountListResource + "?"
            + userIdParam + "=\(userId)"
        request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "GET"
    }
    
    func getURLString() -> String {
        return request.url!.absoluteString
    }
    
}
