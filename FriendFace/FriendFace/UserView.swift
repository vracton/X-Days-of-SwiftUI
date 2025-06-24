//
//  UserView.swift
//  FriendFace
//
//  Created by vracto on 6/23/25.
//

import SwiftUI

struct UserView: View {
    var user: User
    var users: [User]
    @Binding var path: [User]
    
    @State private var userFriends: [User] = []
    
    func getFriends() {
        for friend in user.friends {
            for user in users {
                if friend.id == user.id {
                    userFriends.append(user)
                    break
                }
            }
        }
    }
    
    var body: some View {
        List {
            Section {
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
                Text(user.about)
            }
            
            Section("Contact") {
                VStack(alignment: .leading) {
                    Text("Phone")
                        .fontWeight(.semibold)
                    Text(user.email)
                        .foregroundStyle(.secondary)
                }
                VStack(alignment: .leading) {
                    Text("Address")
                        .fontWeight(.semibold)
                    Text(user.address)
                        .foregroundStyle(.secondary)
                }
            }
            
            if user.tags.count > 0 {
                Section("Tags") {
                    VStack(alignment: .leading) {
                        ForEach(user.tags, id:\.self) {
                            Text("\(Image(systemName: "number")) \($0)")
                                .foregroundStyle(.white)
                                .padding(7)
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                .clipShape(.capsule)
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
            
            if userFriends.count > 0 {
                Section("\(user.name)'s Friends") {
                    ForEach(userFriends) { friend in
                        NavigationLink(value: friend) {
                            HStack {
                                Image(systemName: "person\(friend.isActive ? "" : ".slash").fill")
                                    .font(.largeTitle)
                                VStack(alignment: .leading) {
                                    Text(friend.name)
                                        .font(.headline)
                                    Text("\(friend.company) | Joined \(friend.registered.formatted(date: .numeric, time: .omitted))")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear(perform: getFriends)
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("home", systemImage: "house.fill") {
                path = []
            }
        }
    }
}

#Preview {
    let uuid = UUID()
    let user = User(id: uuid, isActive: true, name: "Joe Size", age: 24, company: "vracto inc.", email: "joe@example.com", address: "10000 West Wyoming Street, Lunar, Ohio, 12345", about: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", registered: .now, tags: [
        "crossaint",
        "avocado",
        "pneappe",
        "crossint",
        "avocdo",
        "pnepple",
        "pneppl",
    ], friends: [
        Friend(id: uuid, name: "Joe Size")
    ])
    UserView(user: user, users: [user], path: .constant([user]))
}

