//
//  Item.swift
//  OpenStreetMapVersuch
//
//  Created by David Kindermann on 02.05.24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
