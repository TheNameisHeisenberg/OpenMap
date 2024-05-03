//
//  ContentView.swift
//  OpenStreetMapVersuch
//
//  Created by David Kindermann on 02.05.24.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var city: String = ""
    @State private var restaurants: [String] = []
    @State private var museums: [String] = []
    @State private var parks: [String] = []
    
    var body: some View {
        VStack {
            SearchBar(city: $city, restaurants: $restaurants, museums: $museums, parks: $parks)
            
            Section(header: Text("Restaurants")) {
                List(restaurants, id: \.self) { restaurant in
                    Text(restaurant)
                }
            }
            
            Section(header: Text("Museums")) {
                List(museums, id: \.self) { museum in
                    Text(museum)
                }
            }
            
            Section(header: Text("Parks")) {
                List(parks, id: \.self) { park in
                    Text(park)
                }
            }
        }
    }
}
