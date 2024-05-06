//
//  SearchPreference.swift
//  OpenStreetMapVersuch
//
//  Created by David Kindermann on 05.05.24.
//

import Foundation
// SearchPreference.swift

enum SearchPreference: String, CaseIterable {
    case restaurants
    case museums
    case parks

    var overpassQuery: String {
        switch self {
        case .restaurants:
            return "node[amenity=restaurant](area.searchArea);out 10;"
        case .museums:
            return "node[amenity=museum](area.searchArea);out 10;"
        case .parks:
            return "node[leisure=park](area.searchArea);out 10;"
        }
    }

    var preference: Preference {
        switch self {
        case .restaurants:
            return .FoodAndDrink
        case .museums:
            return .ArtAndCulture
        case .parks:
            return .Nature
        }
    }
}

