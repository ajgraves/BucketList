//
//  Location.swift
//  BucketList
//
//  Created by Aaron Graves on 8/13/24.
//

import Foundation

struct Location: Codable, Equatable, Identifiable {
    let id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longtitude: Double
}
