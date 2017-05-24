import Foundation
import GoogleMaps

protocol RefreshMapDelegate {
    func refreshMap()
}

class DAO {
    static let sharedInstance = DAO()
    var markers = [GMSMarker]()
    var delegate : RefreshMapDelegate?
    let apiKey = "AIzaSyA7oHTPVRv6RUtuCZRNDQTXxp5Z6t-CNgE"
    
    
    func getresults(searchString: String, location: CLLocationCoordinate2D) {
        let radius = 500
        guard let convertedString = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            else {return}
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(apiKey)&location=\(location.latitude),\(location.longitude)&radius=\(radius)&keyword=\(convertedString)"
        
        guard let url = URL(string: urlString)
            else {return}
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
//            print(response)
            
            guard let myData:Data = data
                else {return}
            
            //Decode the raw data to a dictionary
            guard let json = try? JSONSerialization.jsonObject(with: myData, options: []) as! [String:AnyObject]
                else {return}
            guard let results = json["results"] as? [[String: AnyObject]]
                else {return}
            let result = results[0]
            // first check that locality exists
            guard let resultTypes = result["types"] as? [String],
                let placeID = result["place_id"] as? String,
                let name = result["name"] as? String,
                let geometry = result["geometry"] as? [String:AnyObject],
                let location = geometry["location"] as? [String:Double],
                let lat = location["lat"],
                let lng = location["lng"]
                else {return}
            
        }.resume()
    }
}


