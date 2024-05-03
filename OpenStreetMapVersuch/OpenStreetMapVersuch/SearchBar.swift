//
//  SearchBar.swift
//  OpenStreetMapVersuch
//
//  Created by David Kindermann on 02.05.24.
//

import Foundation
import SwiftUI
import OSLog

import Foundation
import SwiftUI
import OSLog

struct SearchBar: View {
    @Binding var city: String
    @Binding var restaurants: [POI]
        @Binding var museums: [POI]
        @Binding var parks: [POI]
        private let logger = Logger()
    
    var body: some View {
            VStack {
                HStack {
                    TextField("Enter city", text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Hide keyboard
                        fetchPlaces(for: city) // Fetch places
                    }) {
                        Text("Search")
                    }
                }
                .padding()
                
                List(restaurants, id: \.self) { restaurant in
                    Text(restaurant.name)
                }
                .padding(.top)
                
                List(museums, id: \.self) { museum in
                    Text(museum.name)
                }
                .padding(.top)
                
                List(parks, id: \.self) { park in
                    Text(park.name)
                }
                .padding(.top)
            }
        }
    
    private func fetchPlaces(for city: String) {
            logger.log("Fetching Places Started")
            
            // Fetch restaurants
            fetchRestaurants(for: city)
            
            // Fetch museums
            fetchMuseums(for: city)
            
            // Fetch parks
            fetchParks(for: city)
        
            // After fetching all data, save it to a CSV file
            saveDataToCSV(data: combineData(), filename: "places.csv")
        }
    
    
    private func fetchRestaurants(for city: String) {
        logger.log("Fetching Started")
        
        guard let url = URL(string: "http://overpass-api.de/api/interpreter?data=[out:json];area[name=\"\(city)\"]->.searchArea;node[amenity=restaurant](area.searchArea);out 10;")
        else {
            logger.log("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                logger.log("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Log JSON data
            if let jsonString = String(data: data, encoding: .utf8) {
                self.logger.log("JSON Data: \(jsonString)")
            } else {
                self.logger.log("Failed to convert data to string")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                logger.log("Fetching completed")
                if let elements = json?["elements"] as? [[String: Any]] {
                    var fetchedRestaurants: [POI] = []
                    for element in elements {
                        if let tags = element["tags"] as? [String: String],
                           let name = tags["name"],
                           let latitude = element["lat"] as? Double,
                           let longitude = element["lon"] as? Double {
                            let location = "(\(latitude), \(longitude))"
                            let rating = Double(tags["rating"] ?? "0") ?? 0.0
                            fetchedRestaurants.append(POI(name: name, location: location, rating: rating, category: .FoodAndDrink))
                        }
                    }
                    self.restaurants = fetchedRestaurants
                }
            } catch {
                logger.log("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    
    private func fetchParks(for city: String) {
        logger.log("Fetching Parks Started")
        
        guard let url = URL(string: "http://overpass-api.de/api/interpreter?data=[out:json];area[name=\"\(city)\"]->.searchArea;node[leisure=park](area.searchArea);out 10;")
        else {
            logger.log("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                logger.log("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Log JSON data
            if let jsonString = String(data: data, encoding: .utf8) {
                self.logger.log("JSON Data: \(jsonString)")
            } else {
                self.logger.log("Failed to convert data to string")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                logger.log("Fetching Parks completed")
                if let elements = json?["elements"] as? [[String: Any]] {
                    var fetchedParks: [POI] = []
                    for element in elements {
                        if let tags = element["tags"] as? [String: String],
                           let name = tags["name"],
                           let latitude = element["lat"] as? Double,
                           let longitude = element["lon"] as? Double {
                            let location = "(\(latitude), \(longitude))"
                            let rating = Double(tags["rating"] ?? "0") ?? 0.0
                            fetchedParks.append(POI(name: name, location: location, rating: rating, category: .Nature))
                        }
                    }
                    self.parks = fetchedParks
                }
            } catch {
                logger.log("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    
    private func fetchMuseums(for city: String) {
        logger.log("Fetching Museums Started")
        
        guard let url = URL(string: "http://overpass-api.de/api/interpreter?data=[out:json];area[name=\"\(city)\"]->.searchArea;node[amenity=museum](area.searchArea);out 10;")
        else {
            logger.log("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                logger.log("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Log JSON data
            if let jsonString = String(data: data, encoding: .utf8) {
                self.logger.log("JSON Data: \(jsonString)")
            } else {
                self.logger.log("Failed to convert data to string")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                logger.log("Fetching Museums completed")
                if let elements = json?["elements"] as? [[String: Any]] {
                    var fetchedMuseums: [POI] = []
                    for element in elements {
                        if let tags = element["tags"] as? [String: String],
                           let name = tags["name"],
                           let latitude = element["lat"] as? Double,
                           let longitude = element["lon"] as? Double {
                            let location = "(\(latitude), \(longitude))"
                            let rating = Double(tags["rating"] ?? "0") ?? 0.0
                            fetchedMuseums.append(POI(name: name, location: location, rating: rating, category: .ArtAndCulture))
                        }
                    }
                    self.museums = fetchedMuseums
                }
            } catch {
                logger.log("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    
    private func combineData() -> [[String]] {
        var combinedData: [[String]] = []
        
        // Add restaurants data
        for restaurant in restaurants {
            combinedData.append(["\(restaurant.location)", restaurant.name, "\(restaurant.rating)"])
        }
        
        // Add museums data
        for museum in museums {
            combinedData.append(["\(museum.location)", museum.name, "\(museum.rating)"])
        }
        
        // Add parks data
        for park in parks {
            combinedData.append(["\(park.location)", park.name, "\(park.rating)"])
        }
        
        return combinedData
    }
    
    private func saveDataToCSV(data: [[String]], filename: String) {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        
        do {
            var csvText = "poiID,location(x,y),title,rating\n"
            var poiID = 0
            for row in data {
                let rowText = "\(poiID),\(row[0]),\(row[1]),\(row[2])\n"
                csvText.append(rowText)
                poiID += 1
            }
            try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
            logger.log("Data saved to CSV file: \(filename)")
        } catch {
            logger.log("Error saving data to CSV file: \(error.localizedDescription)")
        }
    }

}
