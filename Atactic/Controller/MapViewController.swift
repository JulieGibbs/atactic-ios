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
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        mapView.delegate = self
        
        // Display user's location
        self.mapView.showsUserLocation = true
        self.mapView.userTrackingMode = .follow
        // self.mapView.setCenter(mapView.userLocation.coordinate, animated: true)

        setupUserTrackingButton()

        // Adjust some look & feel params for the infor tab
        self.infoTabView.layer.borderColor = UIColor.lightGray.cgColor
        self.infoTabView.layer.borderWidth = 0.5
        
        // Add Annotations
        let mapAnnotations = createAnnotations()

        self.mapView.addAnnotations(mapAnnotations)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func createAnnotations() -> [AccountAnnotation] {
        let annot1 = AccountAnnotation(accountName: "Farmacia Vázquez",
                                       activeQuests: "Fidelización estratégica, Venta cruzada Q2",
                                       latitude: 41.6563397, longitude: -0.875566, highlight: true)
        let annot2 = AccountAnnotation(accountName: "Farmalis",
                                       activeQuests: "",
                                       latitude: 41.6463397, longitude: -0.876566, highlight: false)
        let annot3 = AccountAnnotation(accountName: "Open Farma",
                                       activeQuests: "",
                                       latitude: 41.6363397, longitude: -0.879566, highlight: false)
        let annot4 = AccountAnnotation(accountName: "Botica de Medicina General",
                                       activeQuests: "Fidelización estratégica",
                                       latitude: 41.6453397, longitude: -0.883266, highlight: true)
        
        return [annot1, annot2, annot3, annot4]
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    /*
     * Executed when DISPLAYING an Annotation.
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










