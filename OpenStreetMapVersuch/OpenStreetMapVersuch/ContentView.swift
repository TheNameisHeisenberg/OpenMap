//
//  ContentView.swift
//  OpenStreetMapVersuch
//
//  Created by David Kindermann on 02.05.24.
//

import SwiftUI
struct ContentView: View {
    @State private var city: String = ""
    @State private var restaurants: [POI] = []
    @State private var museums: [POI] = []
    @State private var parks: [POI] = []
    
    var body: some View {
        VStack {
            SearchBar(city: $city, restaurants: $restaurants, museums: $museums, parks: $parks)
            
            Section(header: Text("Restaurants")) {
                List(restaurants, id: \.id) { restaurant in
                    VStack(alignment: .leading) {
                        Text("Name: \(restaurant.name)")
                        Text("Location: \(restaurant.location)")
                        Text("Rating: \(restaurant.rating)")
                        Text("Category: \(restaurant.category.rawValue)")
                    }
                }
            }
            
            Section(header: Text("Museums")) {
                List(museums, id: \.id) { museum in
                    VStack(alignment: .leading) {
                        Text("Name: \(museum.name)")
                        Text("Location: \(museum.location)")
                        Text("Rating: \(museum.rating)")
                        Text("Category: \(museum.category.rawValue)")
                    }
                }
            }
            
            Section(header: Text("Parks")) {
                List(parks, id: \.id) { park in
                    VStack(alignment: .leading) {
                        Text("Name: \(park.name)")
                        Text("Location: \(park.location)")
                        Text("Rating: \(park.rating)")
                        Text("Category: \(park.category.rawValue)")
                    }
                }
            }
        }
    }
}
