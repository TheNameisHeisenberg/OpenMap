//
//  POI.swift
//  OpenStreetMapVersuch
//
//  Created by David Kindermann on 03.05.24.
//

import Foundation

struct FetchedPoi: Hashable,Identifiable {
    let id = UUID()
    var name: String
    var location: String
    var rating: Double
    var preference: Preference
}

enum Preference: String {
    case FoodAndDrink
    case Shopping
    case ArtAndCulture
    case History
    case Sports
    case Cars
    case Technology
    case Music
    case Nature
    case Spiritual
}
