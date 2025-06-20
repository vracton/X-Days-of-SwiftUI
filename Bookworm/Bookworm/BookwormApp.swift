//
//  BookwormApp.swift
//  Bookworm
//
//  Created by vracto on 6/19/25.
//

import SwiftUI
import SwiftData

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
