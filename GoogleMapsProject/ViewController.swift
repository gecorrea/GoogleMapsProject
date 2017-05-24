import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, RefreshMapDelegate {
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var dataManager = DAO.sharedInstance
    @IBOutlet weak var mapView: GMSMapView!
    var zoomLevel: Float = 15.0
    var hasSetUserLocation = false
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var clearView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
//        self.view.isUserInteractionEnabled = true
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
            //Put it in our label
//            DispatchQueue.main.async {
////                marker.iconView = imageView
                marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
                CATransaction.begin()
                CATransaction.setValue(5, forKey: kCATransactionAnimationDuration)
                marker.appearAnimation = GMSMarkerAnimation.pop
                marker.map = self.mapView
                CATransaction.commit()
//            }
//        CATransaction.begin()
//        CATransaction.setValue(5, forKey: kCATransactionAnimationDuration)
//        marker.appearAnimation = GMSMarkerAnimation.pop
//        marker.map = self.mapView
//        CATransaction.commit()
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let imageURL = URL(string: "http://turntotech.io/wp-content/uploads/2015/12/kaushik-biswas.jpg")
            else {return}
        URLSession.shared.dataTask(with: imageURL) {
            (data, response, error) in
            //print(response)
            
            //Get our json (data) and turn it into a dictionary
            //Check that we have data
            guard let myData:Data = data
                else {return}
            
            let image = UIImage(data: myData)
            let imageView = UIImageView(image: image)
            DispatchQueue.main.async {
                marker.iconView = imageView
            }
        }.resume()
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mapView.clear()
        dataManager.getresults(searchString: searchBar.text!, location: mapView.myLocation!.coordinate)
    }
    
    func refreshMap() {
//        mapView.addAnnotations(dataManager.annotations)
    }

}

