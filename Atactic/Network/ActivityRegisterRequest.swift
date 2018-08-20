//
//  ActivityRegisterRequest.swift
//  Atactic
//
//  Created by Jaime on 15/3/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class ActivityRegisterRequest {
    
    var resourceURLString = RequestConstants.AtacticAPIResourceURL.ActivityListResource
    
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
