//
//  User.swift
//  SwiftDataTest
//
//  Created by vracto on 6/21/25.
//

import Foundation
import SwiftData

@Model
class User {
    var name: String
    var city: String
    var joinDate: Date
    @Relationship(deleteRule: .cascade) var jobs: [Job] = [Job]()
    
    init() {
        self.name = ""
        self.city = ""
        self.joinDate = Date.now
    }
    
    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}

@Model
class Job {
    var name: String
    var priority: Int
    var user: User?
    
    init(name: String, priority: Int, user: User? = nil) {
        self.name = name
        self.priority = priority
        self.user = user
    }
}
