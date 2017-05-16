//
//  ViewController.swift
//  GoogleMapDemoSwift
//
//  Created by Aditya Narayan on 3/10/17.
//  Copyright © 2017 TurnToTech. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController,GMSMapViewDelegate {
    

    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let camera = GMSCameraPosition(target: CLLocationCoordinate2DMake(-33.86, 151.20), zoom: 12.5, bearing:0, viewingAngle: 0)

        self.mapView.isMyLocationEnabled = true
        self.mapView.camera = camera
        self.mapView.isMyLocationEnabled = true
        self.mapView.camera = camera
        self.mapView.delegate = self
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = self.mapView
        marker.infoWindowAnchor = CGPoint(x:0.5, y:-0.25)
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2DMake(-33.872576, 151.243864)
        marker2.title = "Boats"
        marker2.snippet = "In the harbor"
        marker2.map = self.mapView
        marker2.infoWindowAnchor = CGPoint(x:0.5, y:-0.25)
        
        let marker3 = GMSMarker()
        marker3.position = CLLocationCoordinate2DMake(-33.843248, 151.241889)
        marker3.title = "Taronga Zoo"
        marker3.snippet = "Animals!"
        marker3.map = self.mapView
        marker3.infoWindowAnchor = CGPoint(x:0.5, y:-0.25)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = kGMSTypeNormal
            break;
        case 1:
            mapView.mapType = kGMSTypeHybrid
            break;
        case 2:
            mapView.mapType = kGMSTypeSatellite
            break;
        default:
            break;
            
        }

    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        
        guard let infoWindow = Bundle.main.loadNibNamed("MyCustomMarker", owner: nil, options: nil)?[0] as? MyCustomMarker
            else {return nil}
        
        
        infoWindow.title.text = marker.title
        infoWindow.detail.text = marker.snippet
        
        infoWindow.image.image = UIImage(named: "tlogo.png")
        return infoWindow;
    }

}

