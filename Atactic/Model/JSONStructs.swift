//
//  JSONStructs.swift
//  Atactic
//
//  Created by Jaime on 29/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

struct AccountStruct : Codable {
    
    let address : String
    let city : String
    let country : String
    var distance : Float
    let externalId : String
    let id : Int
    let latitude : Double
    let longitude : Double
    let name : String
    let postalCode : String
    let province : String
    let type : String
    
}

struct OwnedAccountStruct : Codable {
    
    let address : String
    let city : String
    let country : String
    let distance : Float
    let externalId : String
    let id : Int
    let latitude : Double
    let longitude : Double
    let name : String
    let owner : AccountOwnerStruct
    let postalCode : String
    let province : String
    let type : String
    
}

struct AccountOwnerStruct : Codable {
    let email : String
    let firstName : String
    let lastName : String
    let password : String
    let position : String
    let score : Int
    let userId : Int
}

struct UserStruct : Codable {
    let userId : Int
    let firstName : String
    let lastName : String
    let position : String
    let score : Int
}

struct CampaignStruct : Codable {
    let id : Int
    let name : String
    let summary : String
    let description : String
    
    let status : String
    
    let startDate : String
    let endDate : String
    
    let owner : UserStruct
    
    let stepScore : Int
    let completionScore : Int
    
    let timeCreated : String
    let lastUpdated: String
}


struct TargetMap : Codable {
    let map : [ParticipationTargets]
}

struct Target : Codable {
    var account : AccountStruct
    var score : Int
    var campaigns : [Participation]
    
    init(acc: AccountStruct) {
        account = acc
        score = 0
        campaigns = []
    }
}

struct ParticipationTargets : Codable {
    let participationId : Int
    let campaignName : String
    let stepScore: Int
    let completionScore: Int
    let currentProgress : Float
    let targets : [AccountStruct]
}

struct Participation : Codable {
    
    let participationId: Int
    let campaign: CampaignStruct
    let participant: AccountOwnerStruct
    let currentProgress : Float
}



