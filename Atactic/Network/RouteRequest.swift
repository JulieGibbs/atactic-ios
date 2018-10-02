//
//  RouteRequest.swift
//  Atactic
//
//  Created by Jaime Lucea on 22/8/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class RouteRequest : HTTPRequest {
    
    // Request parameters
    private let userIdParam = "uid"
    private let latitudeParam = "lat"
    private let longitudeParam = "lon"
    private let waypointsParam = "waypoints"
    
    var request: URLRequest
    
    init(userId: Int, latitude: Double, longitude: Double, waypoints: Int){
        // Build URL
        var urlString = NetworkConstants.APIServiceURL.RouteService + "?" + userIdParam+"=\(userId)"
            urlString += "&"+latitudeParam+"=\(latitude)"+"&"+longitudeParam+"=\(longitude)"
            urlString += "&"+waypointsParam+"=\(waypoints)"

        let myurl = URL(string: urlString)
        
        // Instantiate Request
        request = URLRequest(url: myurl!)
        request.httpMethod = "GET"
    }
    
    func getRequest() -> URLRequest {
        return request
    }
    
    func getURLString() -> String {
        return self.request.url!.absoluteString
    }
    
}

