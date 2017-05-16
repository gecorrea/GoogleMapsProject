//
//  ViewController.swift
//  GoogleMapsProject
//
//  Created by Aditya Narayan on 5/15/17.
//  Copyright © 2017 George Correa. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class ViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startLocation = CLLocationCoordinate2DMake(-33.86, 151.20)
        let currentLocation = CLLocationCoordinate2DMake(40.70859189999999, -74.01492050000002)
        let marker = GMSMarker(position: currentLocation)
        marker.title = "Turn To Tech"
        marker.map = mapView
        
        mapView.camera = GMSCameraPosition.camera(withTarget: startLocation, zoom: 0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentLocation = CLLocationCoordinate2DMake(40.70859189999999, -74.01492050000002)
        CATransaction.begin()
        CATransaction.setValue(3, forKey: kCATransactionAnimationDuration)
        mapView.animate(to: GMSCameraPosition.camera(withTarget: currentLocation, zoom: 15))
        CATransaction.commit()
    }
    
    @IBAction func selectMapView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .normal
            break
        case 1:
            mapView.mapType = .hybrid
            break
        case 2:
            mapView.mapType = .satellite
            break
        default:
            break
        }
        
    }

}

