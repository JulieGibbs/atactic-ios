//
//  GoogleMapsViewController.swift
//  Atactic
//
//  Created by Jaime on 5/8/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps


class GoogleMapsViewController: UIViewController {
    
    override func loadView() {
        
        // Get current location from Location Controller
        let currentLocation = LocationController.global.getMostRecentLocation()
        
        // Set camera con current location
        let camera = GMSCameraPosition.camera(withTarget: currentLocation!.coordinate, zoom: 15)
        
        // Instantiate and Configure Map View
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.setMinZoom(6, maxZoom: 18)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        addMarkers(map: mapView)
    }
    

    func addMarkers(map: GMSMapView) {
        // Add a marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 41.35, longitude: 2.16)
        marker.title = "ATACTIC"
        marker.snippet = "Test Marker"
        marker.map = map
    }
    
    
}


