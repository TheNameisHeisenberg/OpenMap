//
//  POI.swift
//  OpenStreetMapVersuch
//
//  Created by David Kindermann on 03.05.24.
//

import Foundation

struct POI: Hashable {
    let id = UUID()
    let name: String
    let location: String
    let rating: Double
    let category: Category
}

enum Category: String {
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
