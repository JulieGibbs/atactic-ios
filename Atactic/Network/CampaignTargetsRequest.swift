//
//  CampaignTargetsRequest.swift
//  Atactic
//
//  Created by Jaime Lucea on 29/8/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class CampaignTargetsRequest : HTTPRequest {
    
    var request: URLRequest
    
    // Request parameters
    let userIdParam = "uid"
    let participationIdParam = "pid"
    
    //
    // Initialize without location parameters
    //
    init(userId: Int, participationId: Int) {
        let urlStr = RequestConstants.APIServiceURL.CampaignTargets + "?"
            + userIdParam + "=\(userId)" + "&"
            + participationIdParam + "=\(participationId)"
        
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
