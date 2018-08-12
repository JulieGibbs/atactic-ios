//
//  MapViewController.swift
//  Atactic
//
//  Created by Jaime on 10/1/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    // Reference to the Map View
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var infoTabView: UIView!
    
    // LocationManager single instance
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request permision to locate user
        locationManager.requestAlwaysAuthorization()
        
        // Setup locationManager
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest   // Best accuracy not needed
            locationManager.startUpdatingLocation()
        }
        mapView.delegate = self
        
        // Display user's location
        self.mapView.showsUserLocation = true
        self.mapView.userTrackingMode = .follow
        // self.mapView.setCenter(mapView.userLocation.coordinate, animated: true)

        // Set up tracking button (button for centering view on user's location
        setupUserTrackingButton()

        // Adjust some look & feel params for the info tab view
        self.infoTabView.layer.borderColor = UIColor.lightGray.cgColor
        self.infoTabView.layer.borderWidth = 0.5
        
        // Recover user's ID
        let recoveredUserId = UserDefaults.standard.integer(forKey: "uid")
        loadTargetAccounts(userId: recoveredUserId)
        loadNonTargetAccounts(userId: recoveredUserId)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUserTrackingButton() {
        mapView.showsUserLocation = true
        
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor.darkGray.cgColor
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([button.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 10),
                                     button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)])
    }
    
    @IBAction func directionsButtonPressed(_ sender: UIButton) {
        if let acc = mapView.selectedAnnotations[0] as? AccountAnnotation {
            print("Directions button pressed - Account \(acc.title!)")
            
            let destinationLocation = acc.coordinate
            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
            let destination = MKMapItem(placemark: destinationPlacemark)
            destination.name = acc.title
            
            let options = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            
            print("Launching Maps app...")
            destination.openInMaps(launchOptions: options)
        }
    }
    
    /*
    func launchMapsAppWithWaypoints(){
        
        let startLocation = mapView.userLocation.coordinate
        let startPlacemark = MKPlacemark(coordinate: startLocation, addressDictionary: nil)
        let start = MKMapItem(placemark: startPlacemark)
        start.name = "Tu posición"
        
        let waypoint1Location = CLLocationCoordinate2D(latitude: 41.6393397, longitude: -0.865566)
        let waypoint1Placemark = MKPlacemark(coordinate: waypoint1Location, addressDictionary: nil)
        let waypoint1 = MKMapItem(placemark: waypoint1Placemark)
        waypoint1.name = "Parada 1"
        
        let destinationLocation = CLLocationCoordinate2D(latitude: 41.6493397, longitude: -0.885566)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        let destination = MKMapItem(placemark: destinationPlacemark)
        destination.name = "Destino"
        
        let options = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        
        MKMapItem.openMaps(with: [start, waypoint1, destination], launchOptions: options)
    }
     */
    

}


extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    /*
     * Executed when DISPLAYING an Annotation
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            // print("Processing view for user pin")
            return nil
        }
        
        let reuseId = "pin"
        var marker = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        if marker == nil {
            // Instance a new MarkerAnnotationView that will be linked to the viewable Annotation
            marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            // Recover loosely associated MKAnnotation object in order to analyse its preoperties
            let annotation = marker!.annotation as! AccountAnnotation
            
            if (annotation.isPriorityTarget) {
                // Priority target marker
                marker!.glyphImage = UIImage(named: "icon_exclamation_20")!
                marker!.markerTintColor = UIColor.red
            }else{
                marker!.markerTintColor = UIColor.lightGray
            }
        }else{
            marker!.annotation = annotation
        }
        return marker
    }
    
    /*
     * Executed when SELECTING an Annotation
     */
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let acc = view.annotation as? AccountAnnotation {
            
            // Set info tab data to display
            let accountNameLabel = infoTabView.subviews[1] as! UILabel
            let activeQuestsLabel = infoTabView.subviews[2] as! UILabel
            
            accountNameLabel.text = acc.title!
            activeQuestsLabel.text = acc.subtitle!
            
            // Show account info tab with an animation
            infoTabView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.infoTabView.frame.origin.y -= 200
            })
        }
    }
    
    
    /*
     * Excuted when deselecting an annotation
     */
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        // print("ACCOUNT ANNOTATION view DESELECTED")
        
        // Hide account info tab with an animation
        UIView.animate(withDuration: 0.5, animations: {
            self.infoTabView.frame.origin.y += 200
        })
    }
    
}


//
// This extension adds network functionality by defining two functions:
// loadNonTargetAccounts(userId) and loadTargetAccounts(userId),
// which send a request to ATACTIC's server in order to load the accounts
// to be displayed on the map
//
extension MapViewController {
    
    /*
     * Ideally, JSON decoder would directly decode MKAnnotation objects.
     *
     * This could be accomplished via using a custom decoder.
     */
    func loadNonTargetAccounts(userId: Int) {
        
        let request = AccountsRequest(userId: userId, nonTargetOnly: true).request
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let serverResponse = response as? HTTPURLResponse {
                print("AccountService response received - \(serverResponse.statusCode)")
                if (serverResponse.statusCode == 200) {
                    // DECODE JSON response
                    print("Decoding Account List from JSON response")
                    //print(String(data: data!, encoding: .utf8)!)
                    //print()
                    let decoder = JSONDecoder()
                    let accounts = try! decoder.decode([AccountStruct].self, from: data!)
                    print("MapViewController - Loaded \(accounts.count) non-target accounts from the server")
                    
                    // Add account annotations to the Map View in the main queue
                    DispatchQueue.main.async { () -> Void in
                        accounts.forEach { acc in
                            let accountAnnotation = AccountAnnotation(accountName: acc.name, activeQuests: "",
                                                                      latitude: acc.latitude, longitude: acc.longitude,
                                                                      highlight: false)
                            self.mapView.addAnnotation(accountAnnotation)
                        }
                    }
                } else {
                    print("Error code \(serverResponse.statusCode)")
                }
            } else {
                print("No response from server")
            }
        }
        task.resume()
    }
    
    
    func loadTargetAccounts(userId: Int) {
        
        let request = RequestFactory.buildTargetAccountsRequest(userId: userId)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let serverResponse = response as? HTTPURLResponse {
                print("TargetService response received - \(serverResponse.statusCode)")
                if (serverResponse.statusCode == 200) {
                    // DECODE JSON response
                    print("Decoding Target List from JSON response")
                    //print(String(data: data!, encoding: .utf8)!)
                    //print()
                    let decoder = JSONDecoder()
                    let targets = try! decoder.decode(TargetMap.self, from: data!)
                    // print("MapViewController - Loaded \(targets.count) target accounts from the server")
                    
                    // Add account annotations to the Map View in the main queue
                    DispatchQueue.main.async { () -> Void in
                        
                        targets.map.forEach { ptgt in
                            
                            ptgt.targets.forEach { acc in
                            
                                let accountAnnotation = AccountAnnotation(accountName: acc.name, activeQuests: "",
                                                                      latitude: acc.latitude, longitude: acc.longitude,
                                                                      highlight: true)
                                self.mapView.addAnnotation(accountAnnotation)
                            }
                            
                        }
                    }
                } else {
                    print("Error code \(serverResponse.statusCode)")
                }
            } else {
                print("No response from server")
            }
        }
        task.resume()
    }
    
    
}







