//
//  PriorityTargetsRequest.swift
//  Atactic
//
//  Created by Jaime on 21/3/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class PriorityTargetsRequest : HTTPRequest {
    
    var request: URLRequest
    
    // Request parameters
    let userIdParam = "uid"
    let userLocationLatitudeParam = "usrLat"
    let userLocationLongitudeParam = "usrLon"
    
    //
    // Initialize without location parameters
    //
    init(userId: Int) {
        let urlStr = NetworkConstants.APIServiceURL.TargetAccountsForUser + "?"
            + userIdParam + "=\(userId)"
        request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "GET"
    }
    
    //
    // Initialize with all parameter values
    //
    init(userId: Int, userLocationLatitude: Double, userLocationLongitude: Double) {
        let urlStr = NetworkConstants.APIServiceURL.TargetAccountsForUser + "?"
            + userIdParam + "=\(userId)"
            + "&" + userLocationLatitudeParam + "=\(userLocationLatitude)"
            + "&" + userLocationLongitudeParam + "=\(userLocationLongitude)"
        
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
