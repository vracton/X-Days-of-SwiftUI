//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by vracto on 6/23/25.
//

import SwiftUI
import SwiftData

@main
struct FriendFaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
