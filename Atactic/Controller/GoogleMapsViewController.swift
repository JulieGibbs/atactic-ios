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
    
    override func loadView() {
        
        // Get current location from Location Controller
        let currentLocation = LocationController.global.getMostRecentLocation()
        
        // Set camera con current location
        let camera = GMSCameraPosition.camera(withTarget: currentLocation!.coordinate, zoom: 15)
        
        // Instantiate and Configure Map View
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.setMinZoom(6, maxZoom: 18)
        mapView.isMyLocationEnabled = true
        self.view = mapView
        
        let dataHandler = MapDataHandler(viewController: self)
        dataHandler.getData()
    }
    

    func setData (highPriorityMarkers : [ParticipationTargets], lowPriorityMarkers : [AccountStruct]){
        self.priorityMarkers = highPriorityMarkers
        self.secondaryMarkers = lowPriorityMarkers
        drawMarkers()
    }
    
    func drawMarkers() {
        
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
                    marker.map = view as? GMSMapView
                
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
                marker.map = view as? GMSMapView
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


