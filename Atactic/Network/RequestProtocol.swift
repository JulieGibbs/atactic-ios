//
//  HTTPRequest.swift
//  Atactic
//
//  Created by Jaime on 21/3/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

protocol HTTPRequest {
    
    //
    // Shall return a URLRequest object ready to be executed
    //
    var request : URLRequest { get }
    
    //
    // Shall return a String representation of the URL to be called
    //
    func getURLString() -> String
    
}
