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
    
    // LocationManager single instance
    let locationManager = CLLocationManager()
    
    func setupUserTrackingButton() {
        mapView.showsUserLocation = true
        
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor.darkGray.cgColor
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        /*
        let scale = MKScaleView(mapView: mapView)
        scale.legendAlignment = .trailing
        scale.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scale)
        
        NSLayoutConstraint.activate([button.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 10),
                                     button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                                     scale.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -10),
                                     scale.centerYAnchor.constraint(equalTo: button.centerYAnchor)])
         */
        
        NSLayoutConstraint.activate([button.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 10),
                                     button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)])
    }
    
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

        // Add Annotations
        let annot1 = AccountAnnotation(mainText: "Cliente Prioritario 1",
                                       secondaryText: "Fidelización estratégica, Venta cruzada Q2",
                                       latitude: 41.6563397, longitude: -0.875566, highlight: true)
        let annot2 = AccountAnnotation(mainText: "Cliente Normal 1",
                                       secondaryText: "",
                                       latitude: 41.6463397, longitude: -0.876566, highlight: false)
        let annot3 = AccountAnnotation(mainText: "Cliente Normal 2",
                                       secondaryText: "",
                                       latitude: 41.6363397, longitude: -0.879566, highlight: false)
        let annot4 = AccountAnnotation(mainText: "Cliente Prioritario 2",
                                       secondaryText: "Fidelización estratégica, Venta cruzada Q2",
                                       latitude: 41.6263397, longitude: -0.873266, highlight: true)

        self.mapView.addAnnotations([annot1, annot2, annot3, annot4])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // This intenal class extends MKPointAnnotation and will contain a flag indicating
    // whether each object must be painted on the map as a priority target or as
    // a "normal" account
    final internal class AccountAnnotation: MKPointAnnotation {
        
        var isPriorityTarget: Bool
        
        init(mainText: String, secondaryText: String, latitude: Double, longitude: Double, highlight: Bool) {
            isPriorityTarget = highlight
            super.init()
            title = mainText
            subtitle = secondaryText
            let lat = CLLocationDegrees(exactly: latitude)
            let lon = CLLocationDegrees(exactly: longitude)
            coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
        }
        
    }
    

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
 
}




/*
 func openMapInTransitMode() {
 let startLocation = CLLocationCoordinate2D(latitude: 51.50722, longitude: -0.12750)
 let startPlacemark = MKPlacemark(coordinate: startLocation, addressDictionary: nil)
 let start = MKMapItem(placemark: startPlacemark)
 let destinationLocation = CLLocationCoordinate2D(latitude: 51.5149001, longitude: -0.1118255)
 let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
 let destination = MKMapItem(placemark: destinationPlacemark)
 let options = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeTransit]
 MKMapItem.openMapsWithItems([start, destination], launchOptions: options)
 }
 */









