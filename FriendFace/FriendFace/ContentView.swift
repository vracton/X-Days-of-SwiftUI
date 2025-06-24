//
//  ContentView.swift
//  FriendFace
//
//  Created by vracto on 6/23/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var users: [User]
    
    @State private var path: [User] = []
    @State private var msg: String = "Loaded from SwiftData"
    
    func loadData() async {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let decoded = try? decoder.decode([User].self, from: data) {
                for user in decoded {
                    modelContext.insert(user)
                }
                print("fetched data")
            }
        } catch {
            print("Failed to fetch: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(users) { user in
                    NavigationLink(value: user) {
                        HStack {
                            Image(systemName: "person\(user.isActive ? "" : ".slash").fill")
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .font(.headline)
                                Text("\(user.company) | Joined \(user.registered.formatted(date: .numeric, time: .omitted))")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("FriendFace")
            .navigationSubtitle("\(users.count) Friends | \(msg)")
            .navigationDestination(for: User.self) { user in
                UserView(user: user, users: users, path: $path)
            }
            .task {
                if users.count == 0 {
                    msg = "Just Fetched"
                    await loadData()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: User.self)
}
