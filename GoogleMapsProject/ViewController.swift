//
//  ViewController.swift
//  GoogleMapsProject
//
//  Created by Aditya Narayan on 5/15/17.
//  Copyright © 2017 George Correa. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyCvu_VMkRcQv3ZsJHnE7ISF9Ka4K-GJ9bw")
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
    }

}

