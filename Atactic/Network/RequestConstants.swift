//
//  Constants.swift
//  Atactic
//
//  Created by Jaime on 23/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class RequestConstants {
    
    // private static let AtacticServerURL = "http://atactic.jelastic.cloudhosted.es/mobile/"
    
    private static let AtacticServerURL = "http://api.atactic.io/mobile/"
    // private static let AtacticServerURL = "http://192.168.1.38:8080/mobile/"
    // private static let AtacticServerURL = "http://localhost:8080/mobile/"

    private static let APIResourcesURL = AtacticServerURL + "rsc/"
    
    struct APIServiceURL {
        static let ServerVersionResource = APIResourcesURL + "version"
        static let AuthenticationResource = APIResourcesURL + "auth"
        static let QuestResource = APIResourcesURL + "campaign"
        static let UserResource = APIResourcesURL + "user"
        static let AccountsResource = APIResourcesURL + "account"
        static let TargetAccountsForUser = APIResourcesURL + "account/targets"
        static let CampaignTargets = APIResourcesURL + "account/targets/campaign"
        static let ActivityListResource = APIResourcesURL + "activity/list"
        static let RouteService = APIResourcesURL + "account/route"
    }

}
