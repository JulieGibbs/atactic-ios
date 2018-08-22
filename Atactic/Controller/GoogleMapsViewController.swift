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
    @IBOutlet var routeButton: UIBarButtonItem!
    
    
    override func loadView() {
        super.loadView()
        
        routeButton.action = #selector(routeButtonPressed)
        
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
 
    @objc func routeButtonPressed(){
        
        // Instantiate Data Handler and request data
        let dataHandler = MapDataHandler(viewController: self)
        dataHandler.generateRoute()
    }
    
    //
    //
    //
    func displayRoute(origin: CLLocation, route: [AccountStruct]){
        // Will launch the Google Maps App in case it is installed
        // If it isn't installed, it will launch a browser and go to maps.google.com
        // Mobile browsers admit up to 3 waypoints only, including origin and destination
        // The character "|" is used to sepparate waypoints. Must be replaced by %7C
        // Example URL:
        // https://www.google.com/maps/dir/?api=1&origin=Plaza+San+Francisco+Zaragoza&destination=Plaza+del+Pilar+Zaragoza&waypoints=41.6455,-0.890156|41.665,-0.915435|41.6287,-0.883081|41.6291,-0.876407
                
        var urlstring = "https://www.google.com/maps/dir/?api=1"
            urlstring += "&origin=" + String(origin.coordinate.latitude) + "," + String(origin.coordinate.longitude)
            urlstring += "&destination=" + String(route.last!.latitude) + "," + String(route.last!.longitude)
        
        // Add intermediate waypoints
        if (route.count > 1) {
        
            let waypoints = route.dropLast()
            urlstring += "&waypoints="
            
            for acc in waypoints {
                urlstring += String(acc.latitude) + "," + String(acc.longitude)
                if (acc.id != waypoints.last!.id){
                    urlstring += "|"
                }
            }
        }
        
        // Encode URL
        urlstring = urlstring.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlstring)
        
        if let googleMapsURL = URL(string: urlstring) {
            // This will launch an external App
            UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
        } else {
            // TODO displayError
            print("Invalid URL")
        }
    }
    
}


