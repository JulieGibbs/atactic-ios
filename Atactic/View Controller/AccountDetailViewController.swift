//
//  AccountDetailViewController.swift
//  Atactic
//
//  Created by Jaime Lucea on 17/9/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import UIKit
import GoogleMaps

class AccountDetailViewController: UIViewController {
    
    @IBOutlet var accountNameLabel: UILabel!
    @IBOutlet var accountTypeLabel: UILabel!
    @IBOutlet var accountAddressLabel: UILabel!
    @IBOutlet var relevanceScoreLabel: UILabel!
    @IBOutlet var mapView: GMSMapView!
    
    @IBOutlet var campaignsContainerView: UIView!
    @IBOutlet var activityContainerView: UIView!
    
    var account : AccountStruct!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("AccountDetailViewController - Did Load")
        
        /*
        print("Account Detail - NAME: \(account.account.name)")
        print("Account Detail - TYPE: \(account.account.type)")
        print("Account Detail - TYPE: \(account.account.address)")
        */
        
        displayData()
    }
    
    //
    // By overriding the prepare for segue, we can access the AccountCampaignsSegmentController
    //  that manages the Participation List container view in the Account Detail screen
    //  and add the Account ID as a parameter in the segue
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // print("QuestDetailViewController - Preparing for segue")
        if (segue.identifier == "showAccountCampaignsSegue") {
            if let dc = segue.destination as? AccountCampaignsSegmentController {
                dc.accountId = account.id
            }
        } else if (segue.identifier == "showAccountActivitySegue") {
            if let dc = segue.destination as? AccountActivitySegmentController {
                dc.accountId = account.id
            }
        }
    }
    
    
    func displayData(){
    
        // Display account data in header
        accountNameLabel.text = account.name
        accountTypeLabel.text = account.type
        accountAddressLabel.text = account.address
        
        if let score = account.relevance {
            relevanceScoreLabel.text = "\(score)"
        } else {
            relevanceScoreLabel.isHidden = true
        }
        
        // Set-up and display mapView
        // drawMap()
    }
    
    @IBAction func tabSelected(_ sender: UISegmentedControl) {
        // print("AccountDetailViewController - Selected tab changed")
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.campaignsContainerView.alpha = 1
                self.activityContainerView.alpha = 0
            })
        } else if sender.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.campaignsContainerView.alpha = 0
                self.activityContainerView.alpha = 1
            })
        }
    }
    
    /*
    func drawMap(){
        // Add a single marker to the map view
        let marker = GMSMarker()
        let markerPosition = CLLocationCoordinate2D(latitude: account.latitude, longitude: account.longitude)
        
        marker.position = markerPosition
        // marker.title = account.account.name
        marker.map = mapView
        
        // Center camera on marker
        mapView.camera = GMSCameraPosition.camera(withTarget: markerPosition, zoom: 16)
        
        // Add some style!
        do {
            if let styleFileURL = Bundle.main.url(forResource: "GoogleMapsDarkStyle", withExtension: "json"){
                let style = try GMSMapStyle(contentsOfFileURL: styleFileURL)
                mapView.mapStyle = style
            } else {
                print("AccountDetailViewController - Unable to find style resource")
            }
        } catch  {
            print("AccountDetailViewController - Error instancing map style from file")
        }
    } */
    
    
}
