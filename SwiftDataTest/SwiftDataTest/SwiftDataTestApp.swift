//
//  SwiftDataTestApp.swift
//  SwiftDataTest
//
//  Created by vracto on 6/21/25.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
