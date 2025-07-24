//
//  RenameberApp.swift
//  Renameber
//
//  Created by vracto on 7/3/25.
//

import SwiftUI
import SwiftData

@main
struct RenameberApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Entry.self)
    }
}
