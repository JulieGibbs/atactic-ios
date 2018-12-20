//
//  AccountListPresenter.swift
//  Atactic
//
//  Created by Jaime Lucea on 08/12/2018.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

protocol AccountListPresenter {
    
    func displayData(accountList: [AccountStruct])

    func displayError(message: String)
    
}
