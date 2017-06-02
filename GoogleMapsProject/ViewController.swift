import UIKit
import GoogleMaps
import WebKit

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, RefreshMapDelegate, ReloadInfoWindowDelegate, LoadWebViewVC {
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var dataManager = DAO.sharedInstance
    @IBOutlet weak var mapView: GMSMapView!
    var zoomLevel: Float = 15.0
    var hasSetUserLocation = false
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var clearView: UIView!
    var tappedMarker: Marker!
    var infoWindow: CustomInfoWindow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        dataManager.delegate = self
        dataManager.infoWindowDelegate = self
        dataManager.webViewVCDelegate = self
        mapView.delegate = self
        clearView.isUserInteractionEnabled = true
        searchBar.delegate = self
        mapView.bringSubview(toFront: clearView)
    }
    
    // Put a clear view over the map in search mode. Allow touchesBegan to hide the keyboard.
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        clearView.isHidden = false
        return true
    }
    
    // Hide the clear view when editing has ended and allow interaction with the map.
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        clearView.isHidden = true
        return true
    }
    
    // Handle hiding the keyboard.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Allow the user to change the map type.
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
    
    // Set TTT marker.
    @IBAction func placeMarkers(_ sender: Any) {
        let currentLocation = CLLocationCoordinate2DMake(40.70859189999999, -74.01492050000002)
        let marker = GMSMarker(position: currentLocation)
        marker.title = "Turn To Tech"
        marker.snippet = "Learn, Build Apps, Get Hired"
//               marker.iconView = imageView
                marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
                CATransaction.begin()
                CATransaction.setValue(5, forKey: kCATransactionAnimationDuration)
                marker.appearAnimation = GMSMarkerAnimation.pop
                marker.map = self.mapView
                CATransaction.commit()
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let tempName = tappedMarker.title {
            let name = tempName
            if let placeID = tappedMarker.placeID {
                dataManager.getWebURL(placeID: placeID, name: name)
            }
        }
    }
    
    // Set custom info window for tapped marker.
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let newWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)?[0] as! CustomInfoWindow
        tappedMarker = marker as! Marker
        infoWindow = newWindow
        tappedMarker.tracksInfoWindowChanges = true
        if let photoReference = tappedMarker.photoReference {
            dataManager.loadImage(photoReference: photoReference)
        }
        newWindow.locationName.text = tappedMarker.title
        newWindow.locationAddress.text = tappedMarker.snippet
        newWindow.imageView.contentMode = .scaleToFill
        if let rating = tappedMarker.rating {
            newWindow.rating.text = "Rating: \(rating)"
        }
        if let priceLevel = tappedMarker.priceLevel {
            let price = dataManager.loadPriceLevel(priceLevel:priceLevel)
            newWindow.priceLevel.text = "Price Level: \(price)"
        }
        return newWindow
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    // Set initial map view to user's current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !hasSetUserLocation {
            let location: CLLocation = locations.last!
            print("Location: \(location)")
            
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: zoomLevel)
            mapView.camera = camera
            hasSetUserLocation = true
            locationManager.stopUpdatingLocation()
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    // Handle search click from keyboard.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mapView.clear()
        dataManager.beginSearch(searchString: searchBar.text!, location: mapView.myLocation!.coordinate)
    }
    
    // Delegate method from DAO class.
    func refreshMap() {
        for marker in dataManager.markers {
            CATransaction.begin()
            CATransaction.setValue(5, forKey: kCATransactionAnimationDuration)
            marker.icon = GMSMarker.markerImage(with: UIColor.green)
            marker.appearAnimation = GMSMarkerAnimation.pop
            marker.map = self.mapView
            CATransaction.commit()
        }
    }
    
    func reloadInfoWindow() {
        infoWindow.imageView.image = dataManager.image
    }
    
    func loadWebViewVC() {
        let webURLString = dataManager.webString
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webViewVC = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        webViewVC.urlString = webURLString
        
        present(webViewVC, animated: true, completion: nil)
    }

}

