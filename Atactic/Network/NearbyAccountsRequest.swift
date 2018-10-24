//
//  NearbyAccountsRequest.swift
//  Atactic
//
//  Created by Jaime Lucea on 15/10/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class NearbyAccountsRequest : HTTPRequest {
    
    var request: URLRequest
    
    // Request parameters
    let userIdParam = "uid"
    let userLocationLatitudeParam = "usrLat"
    let userLocationLongitudeParam = "usrLon"
    
    //
    // Initialize always with all parameter values
    //
    init(userId: Int, userLocationLatitude: Double, userLocationLongitude: Double) {
        let urlStr = NetworkConstants.APIServiceURL.CheckInEligibleAccountsResource + "?"
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
