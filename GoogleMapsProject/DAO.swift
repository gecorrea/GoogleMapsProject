import Foundation
import GoogleMaps
import GooglePlaces

protocol RefreshMapDelegate {
    func refreshMap()
}

protocol ReloadInfoWindowDelegate {
    func reloadInfoWindow()
}

protocol LoadWebViewVC {
    func loadWebViewVC()
}

class DAO {
    static let sharedInstance = DAO()
    var markers = [Marker]()
    var delegate: RefreshMapDelegate?
    var infoWindowDelegate: ReloadInfoWindowDelegate?
    var webViewVCDelegate: LoadWebViewVC?
    let apiKey = "AIzaSyA7oHTPVRv6RUtuCZRNDQTXxp5Z6t-CNgE"
    var placesClient: GMSPlacesClient!
    let defaultwebsite = "https://www.google.com/#q="
    var image = UIImage()
    let imageCache = NSCache <AnyObject, AnyObject>()
    var webString = String()
    
    
    
    func beginSearch(searchString: String, location: CLLocationCoordinate2D) {
        markers.removeAll()
        let radius = 500
        guard let convertedString = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            else {return}
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(apiKey)&location=\(location.latitude),\(location.longitude)&radius=\(radius)&keyword=\(convertedString)"
        
        guard let url = URL(string: urlString)
            else {return}
        getLocationsAndPlacesIDs(url: url)
    }
    
    func getLocationsAndPlacesIDs(url: URL) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
//                print(response)
            
            guard let myData:Data = data
                else {return}
            
            //Decode the raw data to a dictionary
            guard let json = try? JSONSerialization.jsonObject(with: myData, options: []) as! [String:AnyObject]
                else {return}
            guard let results = json["results"] as? [[String: AnyObject]]
                else {return}
            for result in results {
            guard let title = result["name"] as? String,
                let snippet = result["vicinity"] as? String,
                let placeID = result["place_id"] as? String,
                let location = result["geometry"]?["location"] as? [String: AnyObject],
                let photos = result["photos"] as? NSArray,
                let photosDict = photos[0] as? NSDictionary,
                let photoReference = photosDict["photo_reference"] as? String,
                let priceLevel = result["price_level"] as? Int
                
                    else {continue}
                var rating: String = "N/A"
                if let tempRating = result["rating"] as? String {
                    rating = "\(tempRating)/5"
                }
                var placeLocation = CLLocationCoordinate2D()
                if let lat = location["lat"] as? Double {
                    placeLocation.latitude = lat
                }
                if let lng = location["lng"] as? Double {
                    placeLocation.longitude = lng
                }
                let marker = Marker(title: title, snippet: snippet, position: placeLocation, photoReference: photoReference, priceLevel: priceLevel, rating: rating, placeID: placeID)
                self.markers.append(marker)
            }
            self.delegate?.refreshMap()
        }.resume()
    }
    
    
    func loadImage(photoReference: String) {
        let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=\(photoReference)&key=\(apiKey)"
    
            if let url = URL(string: urlString) {
                
                if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
                    self.image = imageFromCache
                    self.infoWindowDelegate?.reloadInfoWindow()
                    return
                }
                URLSession.shared.dataTask(with: url) {
                    (data, response, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    DispatchQueue.main.async {
                        guard let myData:Data = data
                            else {return}
                        if let myImage = UIImage(data: myData) {
                            let imageToCache = myImage
                            self.imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                            self.image = imageToCache
                            self.infoWindowDelegate?.reloadInfoWindow()
                        }
                    }
                }.resume()
            }
    }
    
    func loadPriceLevel(priceLevel: Int) -> String {
        switch priceLevel {
        case 0:
            return "Free"
        case 1:
            return "$"
        case 2:
            return "$$"
        case 3:
            return "$$$"
        case 4:
            return "$$$$"
        default:
            return "N/A"
        }
    }
    
    func getWebURL(placeID: String, name: String) {
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&key=\(apiKey)"
        
        guard let url = URL(string: urlString)
            else {
                let tempWebString = name.replacingOccurrences(of: " ", with: "+")
                self.webString = self.defaultwebsite.appending(tempWebString)
                self.webViewVCDelegate?.loadWebViewVC()
                return
            }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            //                print(response)
            
            guard let myData:Data = data
                else {return}
            
            //Decode the raw data to a dictionary
            guard let json = try? JSONSerialization.jsonObject(with: myData, options: []) as! [String:AnyObject]
                else {return}
            guard let result = json["result"] as? [String: AnyObject]
                else {return}
            if let tempWebString = result["website"] as? String {
                self.webString = tempWebString
                DispatchQueue.main.async {
                    self.webViewVCDelegate?.loadWebViewVC()
                }
            }
            else {
                let tempWebString = name.replacingOccurrences(of: " ", with: "+")
                self.webString = self.defaultwebsite.appending(tempWebString)
                DispatchQueue.main.async {
                    self.webViewVCDelegate?.loadWebViewVC()
                }
                
            }
        }.resume()
    }
}



