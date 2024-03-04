//
//  Item.swift
//  Goals
//
//  Created by Manuel M T Chakravarty on 04/03/2024.
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
