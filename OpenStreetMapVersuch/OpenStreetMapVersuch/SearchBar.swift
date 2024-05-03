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
    @Binding var restaurants: [String]
        @Binding var museums: [String]
        @Binding var parks: [String]
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
                List(restaurants, id: \.self) { restaurant in
                    Text(restaurant)
                }
                .padding(.top)
                List(museums, id: \.self) { museum in
                    Text(museum)
                }
                .padding(.top)
                List(parks, id: \.self) { park in
                    Text(park)
                }
                .padding(.top)
            }
            .padding()
        }
    
    private func fetchPlaces(for city: String) {
            logger.log("Fetching Places Started")
            
            // Fetch restaurants
            fetchRestaurants(for: city)
            
            // Fetch museums
            fetchMuseums(for: city)
            
            // Fetch parks
            fetchParks(for: city)
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
                    self.restaurants = elements.compactMap { $0["tags"] as? [String: String] } // Extract tags
                                                .compactMap { $0["name"] } // Get restaurant name
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
                    self.parks = elements.compactMap { $0["tags"] as? [String: String] } // Extract tags
                                                .compactMap { $0["name"] } // Get park name
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
                self.logger.log("Museums JSON Data: \(jsonString)")
            } else {
                self.logger.log("Failed to convert data to string")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                logger.log("Fetching Museums completed")
                if let elements = json?["elements"] as? [[String: Any]] {
                    self.museums = elements.compactMap { $0["tags"] as? [String: String] } // Extract tags
                                                .compactMap { $0["name"] } // Get museum name
                }
            } catch {
                logger.log("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}
