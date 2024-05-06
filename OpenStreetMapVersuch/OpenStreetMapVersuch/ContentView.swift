//
//  ContentView.swift
//  OpenStreetMapVersuch
//
//  Created by David Kindermann on 02.05.24.
//

import SwiftUI
struct ContentView: View {
    @State private var city: String = ""
    @State private var searchPreference: SearchPreference = .restaurants
    @State private var searchResults: [FetchedPoi] = []

    var body: some View {
        VStack {
            SearchBar(city: $city, searchPreference: $searchPreference, searchResults: $searchResults)
            
            List(searchResults) { poi in
                VStack(alignment: .leading) {
                    Text("Name: \(poi.name)")
                        .font(.headline)
                    Text("Location: \(poi.location)")
                        .font(.subheadline)
                    Text("Rating: \(poi.rating)")
                        .font(.subheadline)
                    Text("Preference: \(poi.preference.rawValue)")
                        .font(.subheadline)
                }
            }
        }
    }
}
