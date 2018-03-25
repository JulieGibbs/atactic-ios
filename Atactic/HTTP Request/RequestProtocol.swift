//
//  HTTPRequest.swift
//  Atactic
//
//  Created by Jaime on 21/3/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

protocol HTTPRequest {
    
    var request : URLRequest { get }
    
    func getURLString() -> String
    
}
