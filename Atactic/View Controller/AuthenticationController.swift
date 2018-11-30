//
//  AuthenticationController.swift
//  Atactic
//
//  Created by Jaime Lucea on 28/11/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

protocol AuthenticationController {
    
    func onAuthenticationSucess(token: String)
    
    func onAuthenticationFailure(message: String?)
    
}

