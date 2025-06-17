//
//  Mission.swift
//  Moonshot
//
//  Created by vracto on 6/14/25.
//

import Foundation

struct Mission: Codable, Identifiable, Hashable {
    struct CrewMember: Codable, Hashable {
        let name: String
        let role: String
    }
    
    let id: Int
    let launchDate: Date?
    let crew: [CrewMember]
    let description: String
    
    var imageName: String {
        "apollo\(id)"
    }
    
    var displayName: String {
        "Apollo \(id)"
    }
    
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "Lost"
    }
}
