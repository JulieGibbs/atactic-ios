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
        print("LocationController - Reporting location: \(String(describing: mostRecentLocation?.coordinate))")
        checkAuthorizationStatus()
        return mostRecentLocation
    }
    
    private func checkAuthorizationStatus(){
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            // locationManager.requestWhenInUseAuthorization()
            print("LocationController - Location authorization status not determined")
            break
            
        case .restricted, .denied:
            // Disable location features
            // disableMyLocationBasedFeatures()
            print("LocationController - Location authorization DENIED")
            break
            
        case .authorizedWhenInUse:
            // Enable basic location features
            // enableMyWhenInUseFeatures()
            print("LocationController - Location authorization granted (when in use)")
            break
            
        case .authorizedAlways:
            // Enable any of your app's location features
            // enableMyAlwaysFeatures()
            print("LocationController - Location authorization granted (always)")
            break
        }
    }

}

