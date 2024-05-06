//
//  SearchBar.swift
//  OpenStreetMapVersuch
//
//  Created by David Kindermann on 02.05.24.
//

import Foundation
import SwiftUI
import OSLog
struct SearchBar: View {
    @Binding var city: String
    @Binding var searchPreference: SearchPreference
    @Binding var searchResults: [FetchedPoi]
    
    private let logger = Logger()
    
    var body: some View {
        VStack {
            TextField("Enter city", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Picker(selection: $searchPreference, label: Text("Search Preference")) {
                ForEach(SearchPreference.allCases, id: \.self) { (preference: SearchPreference) -> Text in
                    return Text(preference.rawValue.capitalized)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Hide keyboard
                fetchPOIs(for: city, searchPreference: searchPreference)
            }) {
                Text("Search")
            }
            .padding()
            
            Button(action: {
                saveDataToCSV()
            }) {
                Text("Save")
            }
            .padding()
        }
    }
    
    private func fetchPOIs(for city: String, searchPreference: SearchPreference) {
        logger.log("Fetching \(searchPreference.rawValue) Started")
        guard let url = createURL(for: city, searchPreference: searchPreference) else {
            logger.log("Invalid URL")
            return
        }
        logger.log("URL: \(url.absoluteString)")
        fetchData(from: url, searchPreference: searchPreference)
    }
    
    private func createURL(for city: String, searchPreference: SearchPreference) -> URL? {
        let urlString = "http://overpass-api.de/api/interpreter?data=[out:json];area[name=\"\(city)\"]->.searchArea;\(searchPreference.overpassQuery)"
        return URL(string: urlString)
    }
    
    private func fetchData(from url: URL, searchPreference: SearchPreference) {
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
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
            parseData(data: data, searchPreference: searchPreference)
        }.resume()
    }
    
    private func parseData(data: Data, searchPreference: SearchPreference) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            logger.log("Fetching \(searchPreference.rawValue) completed")
            if let elements = json?["elements"] as? [[String: Any]] {
                self.searchResults = parseElements(elements: elements)
            }
        } catch {
            logger.log("Error parsing JSON: \(error.localizedDescription)")
        }
    }
    
    private func parseElements(elements: [[String: Any]]) -> [FetchedPoi] {
        var fetchedPOIs: [FetchedPoi] = []
        for element in elements {
            if let tags = element["tags"] as? [String: String],
               let name = tags["name"],
               let latitude = element["lat"] as? Double,
               let longitude = element["lon"] as? Double {
                let location = "(\(latitude), \(longitude))"
                let rating = Double(tags["rating"] ?? "0") ?? 0.0
                let preference = Preference(rawValue: tags["preference"] ?? "") ?? .FoodAndDrink
                fetchedPOIs.append(FetchedPoi(name: name, location: location, rating: rating, preference: preference))
            }
        }
        return fetchedPOIs
    }
    
    private func saveDataToCSV() {
        let fileName = "search_results.csv"
        let directoryURL = URL(fileURLWithPath: "/Users/david_kindermann/Documents/GitHub/OpenMap/OpenStreetMapVersuch")
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        var csvText = "poiID,location,title\n"
        
        for (index, poi) in searchResults.enumerated() {
            let location = poi.location.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
            let line = "\(index),\(location),\(poi.name)\n"
            csvText.append(line)
        }
        
        do {
            try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
            print("CSV file saved at: \(fileURL.path)")
        } catch {
            print("Failed to save CSV file: \(error.localizedDescription)")
        }
    }
}
