import Foundation
import GoogleMaps
import GooglePlaces

protocol RefreshMapDelegate {
    func refreshMap()
}

class DAO {
    static let sharedInstance = DAO()
    var markers = [GMSMarker]()
    var delegate : RefreshMapDelegate?
    var placesClient: GMSPlacesClient!
    
    
    func getresults(searchString: String, location: CLLocationCoordinate2D, radius: Double) {
        placesClient = GMSPlacesClient.shared()
    }
}


