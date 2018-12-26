//
//  Constants.swift
//  Atactic
//
//  Created by Jaime on 23/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class NetworkConstants {
    
    // private static let AtacticServerURL = "http://atactic.jelastic.cloudhosted.es/mobile/"
    // private static let AtacticServerURL = "http://atactic.jcloud.ik-server.com/mobile/"
    
    // private static let AtacticServerURL = "http://api.atactic.io/mobile/"
    // private static let AtacticServerURL = "http://192.168.1.36:8080/mobile/"
    private static let AtacticServerURL = "http://localhost:8080/mobile/"

    private static let APIResourcesURL = AtacticServerURL + "rsc/"
    
    struct APIServiceURL {
        
        static let ServerVersionResource = APIResourcesURL + "version"
        static let AuthenticationResource = APIResourcesURL + "auth"
        
        static let CampaignResource = APIResourcesURL + "campaign"
        static let AccountCampaignsResource = APIResourcesURL + "campaign/acc"
        
        static let AccountResource = APIResourcesURL + "account"
        static let AccountMapResource = APIResourcesURL + "account/map"
        static let TargetAccountsForUser = APIResourcesURL + "account/targets"
        static let CampaignTargets = APIResourcesURL + "account/targets/campaign"
        static let RouteService = APIResourcesURL + "account/route"
        static let CheckInEligibleAccountsResource = APIResourcesURL + "account/nearby"
        
        static let ActivityListResource = APIResourcesURL + "activity/list"
        static let AccountActivityResource = APIResourcesURL + "activity/account"
        static let CheckInResource = APIResourcesURL + "activity/checkin"
        
        static let UserResource = APIResourcesURL + "user"
        static let ProfileResource = APIResourcesURL + "user/profile"
        static let PasswordResource = APIResourcesURL + "user/pwd"
        static let TenantConfigurationResource = APIResourcesURL + "user/config"
    }

}
