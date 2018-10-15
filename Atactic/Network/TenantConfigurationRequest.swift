//
//  TenantConfigurationRequest.swift
//  Atactic
//
//  Created by Jaime Lucea on 14/10/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class TenantConfigurationRequest : HTTPRequest {
    
    internal var request: URLRequest
    
    // Parameters
    let userIdParam = "uid"
    
    init(userId : Int){
        let urlStr = NetworkConstants.APIServiceURL.TenantConfigurationResource + "?\(userIdParam)=\(userId)"
        request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "GET"
    }
    
    func getURLString() -> String {
        return self.request.url!.absoluteString
    }
    
    func getRequest() -> URLRequest {
        return request
    }
}
