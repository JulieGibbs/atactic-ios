//
//  LocationController.swift
//  Atactic
//
//  Created by Jaime on 21/3/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {
    
    // Singleton pattern
    static let global = LocationController()
    
    var mostRecentLocation : CLLocation? = nil
    
    let locationManager : CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        super.init()
        locationManager.delegate = self
    }
    
    func start() {
        print("LocationController - Initiating")
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("LocationController - User location updated")
        if let location = locations.first {
            print(location.coordinate)
            mostRecentLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationController - LocationManager ERROR")
        print(error.localizedDescription)
    }
    
    func getMostRecentLocation() -> CLLocation? {
        return mostRecentLocation
    }
    
}

