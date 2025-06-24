//
//  ContentView.swift
//  FriendFace
//
//  Created by vracto on 6/23/25.
//

import SwiftUI

struct ContentView: View {
    @State private var users: [User] = [User]()
    
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
                users = decoded
            }
        } catch {
            print("Failed to fetch: \(error.localizedDescription)")
        }
    }
    
    @State private var path: [User] = []
    
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
            .navigationDestination(for: User.self) { user in
                UserView(user: user, users: users, path: $path)
            }
            .task {
                if users.count == 0 {
                    await loadData()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
