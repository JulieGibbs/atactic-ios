//
//  VisitStruct.swift
//  Atactic
//
//  Created by Jaime on 15/3/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

struct VisitStruct : Codable {
    
    let account : OwnedAccountStruct
    let author : AccountOwnerStruct
    let comments : String
    let id : Int
    let latitude : Double
    let longitude : Double
    let timeReported : String
    
}

