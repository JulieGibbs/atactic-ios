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
    let distance : Float
    let externalId : String
    let id : Int
    let latitude : Double
    let longitude : Double
    let name : String
    let postalCode : String
    let province : String
    let segment : String
    let type : String
    
}

struct QuestParticipationStruct : Codable {
    
    let participationId: Int
    let campaign: QuestStruct
    
    let currentStep : Int
    let totalSteps : Int
    let completed : Bool
}

struct QuestStruct : Codable {
    let id : Int
    let name : String
    let summary : String
    let description : String
    
    let type : String
    let status : String
    
    let startDate : String
    let endDate : String
    
    let owner : UserStruct
    
    let visitScore : Int
    let completionScore : Int
    
    let timeCreated : String
    let lastUpdated: String
}

struct UserStruct : Codable {
    let userId : Int
    let firstName : String
    let lastName : String
    let position : String
    let score : Int
}

struct ParticipationTargetStruct : Codable {
    
    let account : AccountStruct
    let checked : Int
    let participation : QuestParticipationStruct
    let pk : Int
    
}
