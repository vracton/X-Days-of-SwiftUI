//
//  DataTypes.swift
//  FriendFace
//
//  Created by vracto on 6/23/25.
//

import SwiftUI

struct User: Identifiable, Codable, Hashable {
    var id: UUID
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [Friend]
    
    static func ==(lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Friend: Codable {
    var id: UUID
    var name: String
}
