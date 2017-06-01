import GoogleMaps

class Marker: GMSMarker {
    
    var website: URL?
    var image: UIImage?
    var photoReference: String?
    var priceLevel: Int?
    var rating: String?
    var placeID: String?
    var ratingLevel: String?
    
    init(title:String, snippet:String, position:CLLocationCoordinate2D, photoReference: String, priceLevel: Int, rating: String, placeID: String) {
        super.init()
        self.title = title
        self.snippet = snippet
        self.position = position
        self.photoReference = photoReference
        self.priceLevel = priceLevel
        self.rating = rating
        self.placeID = placeID
    }
}
