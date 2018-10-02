//
//  QuestListRequest.swift
//  Atactic
//
//  Created by Jaime on 25/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class QuestListRequest {
    
    var resourceURLString = NetworkConstants.APIServiceURL.QuestResource
    
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
