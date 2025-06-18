//
//  Activity.swift
//  Habits
//
//  Created by vracto on 6/17/25.
//

import SwiftUI

struct Activity: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var desc: String
    var count: Int = 0
}

@Observable
class Activities: Codable {
    var activities: [Activity] = [Activity]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(activities) {
                UserDefaults.standard.set(encoded, forKey: "activities")
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "activities") {
            if let decoded = try? JSONDecoder().decode([Activity].self, from: data) {
                activities = decoded
                return
            }
        }
        
        activities = []
    }
    
    func add(_ activity: Activity) {
        activities.append(activity)
    }
    
    func remove(atOffsets offset: IndexSet) {
        activities.remove(atOffsets: offset)
    }
}
