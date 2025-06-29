//
//  Location.swift
//  BucketList
//
//  Created by vracto on 6/28/25.
//

import Foundation
import MapKit

struct Location: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var desc: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    #if DEBUG
    static let example = Location(name: "Buckingham Palace", desc: "Lit by over 40,000 lightbulbs.", latitude: 51.501, longitude: -0.141)
    #endif
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
