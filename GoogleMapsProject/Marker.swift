import GoogleMaps

class Marker: GMSMarker {
    var placeID: String?
    var website: URL?
    var image : UIImage?
    
    init(placeID: String, title:String, snippet:String, position:CLLocationCoordinate2D) {
        super.init()
        self.placeID = placeID
        self.title = title
        self.snippet = snippet
        self.position = position
    }
}
