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
    
    var priorityMarkers : [ParticipationTargets] = []
    var secondaryMarkers : [AccountStruct] = []
    
    @IBOutlet var map: GMSMapView!
    
    override func loadView() {
        
        super.loadView()
        print("GOOGLE MAPS VIEW CONTROLLER - LOAD VIEW")
        
        // Get current location from Location Controller
        let currentLocation = LocationController.global.getMostRecentLocation()
        
        // Center camera on current location
        let camera = GMSCameraPosition.camera(withTarget: currentLocation!.coordinate, zoom: 15)
        
        // Configure Map View
        map.camera = camera
        map.setMinZoom(6, maxZoom: 18)
        map.isMyLocationEnabled = true

        // Instantiate Data Handler and request data
        let dataHandler = MapDataHandler(viewController: self)
        dataHandler.getData()
    }
    

    func setData (highPriorityMarkers : [ParticipationTargets], lowPriorityMarkers : [AccountStruct]){
        self.priorityMarkers = highPriorityMarkers
        self.secondaryMarkers = lowPriorityMarkers
        drawMarkers(mapView: map)
    }
    
    func drawMarkers(mapView: GMSMapView) {
        
        var drawn : [Int] = []
        
        // Draw highlighted markets
        for pt in priorityMarkers {
            
            for tgt in pt.targets {
                
                if (!drawn.contains(tgt.id)){
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: tgt.latitude, longitude: tgt.longitude)
                    marker.icon = #imageLiteral(resourceName: "marker_important_32")
                    marker.title = tgt.name
                    marker.snippet = pt.campaignName
                    marker.map = mapView
                
                    drawn.append(tgt.id)
                }
            }
        }
        
        // Draw low priority markets
        for account in secondaryMarkers {
            
            if (!drawn.contains(account.id)) {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: account.latitude, longitude: account.longitude)
                marker.icon = #imageLiteral(resourceName: "marker_neutral_24g")
                marker.title = account.name
                // marker.snippet = account.type
                marker.map = mapView
            }
        }
    }
    
    /*
    func addSampleMarker(map: GMSMapView) {
        
        // Add a marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 41.35, longitude: 2.16)
        marker.title = "ATACTIC"
        marker.snippet = "Test Marker"
        marker.map = map
    }
    */
    
}


