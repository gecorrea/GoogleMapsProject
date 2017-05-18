import Foundation
import GoogleMaps

class DAO {
    static let sharedInstance = DAO()
    var markers = [GMSMarker]()
}
