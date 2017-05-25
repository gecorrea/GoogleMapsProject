import Foundation
import GoogleMaps
import GooglePlaces

protocol RefreshMapDelegate {
    func refreshMap()
}

class DAO {
    static let sharedInstance = DAO()
    var markers = [Marker]()
    var delegate : RefreshMapDelegate?
    let apiKey = "AIzaSyA7oHTPVRv6RUtuCZRNDQTXxp5Z6t-CNgE"
    var placesClient : GMSPlacesClient!
    let defaultwebsite = "https://www.google.com/#q="
    
    
    
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
                print(response)
            
            guard let myData:Data = data
                else {return}
            
            //Decode the raw data to a dictionary
            guard let json = try? JSONSerialization.jsonObject(with: myData, options: []) as! [String:AnyObject]
                else {return}
            guard let results = json["results"] as? [[String: AnyObject]]
                else {return}
            for result in results {
            // first check that locality exists
            guard let placeID = result["place_id"] as? String,
                let location = result["geometry"]?["location"] as? [String: AnyObject]
                else {return}
                let lat = location["lat"] as? Double
                let lng = location["lng"] as? Double
                var placeLocation = CLLocationCoordinate2D()
                placeLocation.latitude = lat!
                placeLocation.longitude = lng!
                let marker = Marker(placeID: placeID, title: "", snippet: "", position: placeLocation)
                self.markers.append(marker)
            }
            self.delegate?.refreshMap()
        }.resume()
    }
    
//    func getResluts() {
//        for placeID in placeIDs {
//            performAllCallBacks(placeID: placeID)
//        }
//    }
    
//    func performAllCallBacks(placeID: String) {
//        placesClient.lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
//            if let error = error {
//                // TODO: handle the error.
//                print("Error: \(error.localizedDescription)")
//            } else {
//                if let firstPhoto = photos?.results.first {
//                    self.loadImageForMetadata(photoMetadata: firstPhoto)
//                }
//            }
//        }

//        placesClient.lookUpPlaceID(placeID, callback: { (place, error) in
//            if let error = error {
//                print("lookup place id query error: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let place = place
//                else {
//                    print("No place details for \(placeID)")
//                    return
//            }
//            print(place)
//            let name = place.name
//            let coordinate = place.coordinate
//            let phoneNumber = place.phoneNumber
//            guard let website = place.website
//                else {
//                    let nameForWeb = name.replacingOccurrences(of: " ", with: "+")
//                    let website = URL(string: self.defaultwebsite.appending(nameForWeb))
//                    let newMarker = Marker(title: name, snippet: phoneNumber!, position: coordinate, website: website!, image: self.image)
//                    self.markers.append(newMarker)
//                    self.delegate?.refreshMap()
//                    return
//                    
//            }
//            
//            let newMarker = Marker(title: name, snippet: phoneNumber!, position: coordinate, website: website, image: self.image)
//            self.markers.append(newMarker)
//            self.delegate?.refreshMap()
//        })
//    }
    
//    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
//        placesClient.loadPlacePhoto(photoMetadata, callback: {
//            (photo, error) -> Void in
//            if let error = error {
//                // TODO: handle the error.
//                print("Error: \(error.localizedDescription)")
//            } else {
//                self.image = photo!;
//            }
//        })
//    }
}



