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
    
    var priorityAccounts : [ParticipationTargets] = []
    var nonPriorityAccounts : [AccountStruct] = []
    
    var mapMarkers : [GMSMarker] = []
    
    @IBOutlet var map: GMSMapView!
    @IBOutlet var routeButton: UIBarButtonItem!
    @IBOutlet var checkInView: UIView!
    
    
    override func loadView() {
        super.loadView()
        
        routeButton.action = #selector(routeButtonPressed)
        
        setupMap()
        
        // Check if checkIn is enabled and hide or show the check-oin button accordingly
        let isCheckInEnabled = UserDefaults.standard.bool(forKey: "checkInEnabled")
        if (isCheckInEnabled) {
            print("GoogleMapsViewController - CheckIn is enabled: will display button")
            map.addSubview(checkInView)
        } else {
            print("GoogleMapsViewController - CheckIn is disabled: will hide Button")
        }
        
        // Instantiate Data Handler and request data
        let dataHandler = MapDataHandler(viewController: self)
        dataHandler.getData()
    }
    
    private func setupMap(){
        updateMapCamera()
        map.setMinZoom(6, maxZoom: 18)
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
    }
    
    private func updateMapCamera() {
        
        var cameraPosition : GMSCameraPosition
        let defaultCameraLocation = CLLocationCoordinate2D(latitude: 39.842782, longitude: -3.572391)
        
        // Get current location from Location Controller
        if let currentLocation = LocationController.global.getMostRecentLocation() {
            // Center camera on current location
            cameraPosition = GMSCameraPosition.camera(withTarget: currentLocation.coordinate, zoom: 15)
        } else {
            // In case current location is unavailable, center camera on a target
            if let aTarget = self.priorityAccounts.first?.targets.first {
                let targetLocation = CLLocationCoordinate2D(latitude: aTarget.latitude, longitude: aTarget.longitude)
                cameraPosition = GMSCameraPosition.camera(withTarget: targetLocation, zoom: 12)
            } else {
                cameraPosition = GMSCameraPosition.camera(withTarget: defaultCameraLocation, zoom: 8)
            }
        }
        map.camera = cameraPosition
        // map.animate(to: cameraPosition)
    }

    func displayData (highPriorityMarkers : [ParticipationTargets], lowPriorityMarkers : [AccountStruct]){
        self.priorityAccounts = highPriorityMarkers
        self.nonPriorityAccounts = lowPriorityMarkers
        
        drawMarkers(mapView: map)
        
        updateMapCamera()
    }
    
    
    private func adjustMarkerPosition(position: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        let minoffset = -0.00025
        let maxoffset = 0.00025
        
        let latVariation = (Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)) * (maxoffset - minoffset) + minoffset
        let lonVariation = (Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)) * (maxoffset - minoffset) + minoffset
        
        let modifiedLat = position.latitude + latVariation
        let modifiedLon = position.longitude + lonVariation
        
//        print("Adjusting marker position with an offset")
//        print("New coordinates - lat: \(modifiedLat) lon: \(modifiedLon)")
//        print("LatVariation= \(latVariation)")
//        print("LonVariation= \(lonVariation)")
        return CLLocationCoordinate2D(latitude: modifiedLat, longitude: modifiedLon)
    }
    
    private func drawMarkers(mapView: GMSMapView) {
        
        var drawnAccountIds : [Int] = []
        
        // Draw highlighted markets
        for pt in priorityAccounts {
            
            for tgt in pt.targets {
                
                if (!drawnAccountIds.contains(tgt.id)){
                    let marker = GMSMarker()
                    var markerPosition = CLLocationCoordinate2D(latitude: tgt.latitude, longitude: tgt.longitude)

                    // Add a random latitude or longitude offset to different markers placed on the exact same spot
                    for m in mapMarkers {
                        if (m.position.latitude == markerPosition.latitude && m.position.longitude == markerPosition.longitude) {
                            markerPosition = adjustMarkerPosition(position: markerPosition)
                        }
                    }
                    
                    marker.position = markerPosition
                    marker.icon = #imageLiteral(resourceName: "marker_important_32")
                    marker.title = tgt.name
                    marker.snippet = pt.campaignName
                    
                    marker.map = mapView
                    mapMarkers.append(marker)
                    
                    drawnAccountIds.append(tgt.id)
                }
                // else if account has already been drawn, add the other campaign name to the marker snippet
                
            }
        }
        
        // Draw low priority markets
        for account in nonPriorityAccounts {
            
            if (!drawnAccountIds.contains(account.id)) {
                let marker = GMSMarker()
                var markerPosition = CLLocationCoordinate2D(latitude: account.latitude, longitude: account.longitude)

                // Add a random latitude or longitude offset to different markers placed on the exact same spot
                for m in mapMarkers {
                    if (m.position.latitude == markerPosition.latitude && m.position.longitude == markerPosition.longitude) {
                        markerPosition = adjustMarkerPosition(position: markerPosition)
                    }
                }
                marker.position = markerPosition
                marker.icon = #imageLiteral(resourceName: "marker_neutral_24g")
                marker.title = account.name
                // marker.snippet = account.type
                
                marker.map = mapView
                mapMarkers.append(marker)
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
    // Will launch the Google Maps App in case it is installed
    // If it isn't installed, it will launch a browser and go to maps.google.com
    //
    func displayRoute(origin: CLLocation, route: [AccountStruct]){

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
            UIApplication.shared.open(googleMapsURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            // TODO displayError
            print("Invalid URL")
        }
    }
    
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
