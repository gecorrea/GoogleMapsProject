import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    var locationManager:CLLocationManager = CLLocationManager()
    var dataManager = DAO.sharedInstance
    
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
//        let startLocation = CLLocationCoordinate2DMake(-33.86, 151.20)
        let currentLocation = CLLocationCoordinate2DMake(40.70859189999999, -74.01492050000002)
//        let marker = GMSMarker(position: currentLocation)
//        marker.title = "Turn To Tech"
//        marker.appearAnimation = GMSMarkerAnimation.pop
//        marker.map = mapView
        
        mapView.camera = GMSCameraPosition.camera(withTarget: currentLocation, zoom: 15)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let currentLocation = CLLocationCoordinate2DMake(40.70859189999999, -74.01492050000002)
//        let marker = GMSMarker(position: currentLocation)
//        marker.title = "Turn To Tech"
//        marker.appearAnimation = GMSMarkerAnimation.pop
//        marker.map = mapView
//        mapView.camera = GMSCameraPosition.camera(withTarget: currentLocation, zoom: 15)
//        CATransaction.begin()
//        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
//        mapView.animate(to: GMSCameraPosition.camera(withTarget: currentLocation, zoom: 15))
//        CATransaction.commit()
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

}

