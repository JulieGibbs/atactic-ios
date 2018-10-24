//
//  CheckInRequest.swift
//  Atactic
//
//  Created by Jaime Lucea on 17/10/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class CheckInRequest : HTTPRequest {
    
    var request: URLRequest
    
    // Request parameters
    let userIdParam = "uid"
    let accountIdParam = "account"
    let notesParam = "comments"
    let locationLatitudeParam = "lat"
    let locationLongitudeParam = "lon"
    
    init(userId: Int, accountId: Int, comments: String, latitude: Double, longitude: Double){
        
        let rscStr = NetworkConstants.APIServiceURL.CheckInResource
        let paramStr = "\(userIdParam)=\(userId)"
            + "&\(accountIdParam)=\(accountId)" + "&\(notesParam)=\(comments)"
            + "&\(locationLatitudeParam)=\(latitude)" + "&\(locationLongitudeParam)=\(longitude)"

        request = URLRequest(url: URL(string: rscStr)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = paramStr.data(using: .utf8)
    }
    
    func getRequest() -> URLRequest {
        return request
    }
    
    func getURLString() -> String {
        return self.request.url!.absoluteString
    }
    
}
