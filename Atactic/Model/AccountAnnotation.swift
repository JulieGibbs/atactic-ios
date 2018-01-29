//
//  AccountAnnotation.swift
//  Atactic
//
//  Created by Jaime on 22/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

/*
 * This is the class of the objects that will represent accounts on the map view.
 *
 * Annotations (or map markers) contain all information about the object so that the view can
 * access it through the map management bult-in functions.
 *
 * The class contains a flag indicating wether this object is a priority target, as well as
 * the account's name, location data (address & coordinates) and the active quests that make it
 * a relevant target.
 *
 */
class AccountAnnotation: MKPointAnnotation {

    var isPriorityTarget: Bool   
    
    init(accountName: String, activeQuests: String, latitude: Double, longitude: Double, highlight: Bool) {
        
        // Initialization of non-inherited fields
        isPriorityTarget = highlight
        
        super.init()
        
        // Initialization of inherited fields
        self.title = accountName
        self.subtitle = activeQuests
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: latitude)!,
                                                 longitude: CLLocationDegrees(exactly: longitude)!)
    }
    
}
