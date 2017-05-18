import Foundation
import GoogleMaps
import GooglePlaces

class DAO {
    static let sharedInstance = DAO()
    var markers = [GMSMarker]()
}
