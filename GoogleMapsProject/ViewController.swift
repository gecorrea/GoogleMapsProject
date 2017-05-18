import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var dataManager = DAO.sharedInstance
    @IBOutlet weak var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var hasSetUserLocation = false
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        mapView.delegate = self
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
    
    
    @IBAction func placeMarkers(_ sender: Any) {
        let currentLocation = CLLocationCoordinate2DMake(40.70859189999999, -74.01492050000002)
        let marker = GMSMarker(position: currentLocation)
        marker.title = "Turn To Tech"
        CATransaction.begin()
        CATransaction.setValue(5, forKey: kCATransactionAnimationDuration)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
        CATransaction.commit()
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
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }

}

