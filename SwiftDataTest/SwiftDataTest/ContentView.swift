//
//  ContentView.swift
//  SwiftDataTest
//
//  Created by vracto on 6/21/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<User> { user in
        user.name.localizedStandardContains("R") &&
        user.city == "London"
    },sort: \User.name) var users: [User]
    
    @State private var path: [User] = [User]()
    @State private var showUpcomingOnly: Bool = false
    @State private var sortOrder: [SortDescriptor<User>] = [SortDescriptor(\User.name), SortDescriptor(\User.joinDate)]
    
    var body: some View {
        NavigationStack(path: $path) {
            UsersView(minJoinDate: showUpcomingOnly ? .now : .distantPast, sortOrder: sortOrder)
            .navigationTitle("Users")
            .navigationDestination(for: User.self) { user in
                EditUserView(user: user)
            }
            .toolbar {
                Button("Add Samples", systemImage: "testtube.2") {
                    if let fUsers = try? modelContext.fetch(FetchDescriptor<User>()) {
                        for user in fUsers {
                            modelContext.delete(user)
                        }
                    }
                    let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
                    let second = User(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
                    let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
                    let fourth = User(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))
                    let user1 = User(name: "Piper Chapman", city: "New York", joinDate: .now)
                    let job1 = Job(name: "Organize sock drawer", priority: 3)
                    let job2 = Job(name: "Make plans with Alex", priority: 4)

                    modelContext.insert(first)
                    modelContext.insert(second)
                    modelContext.insert(third)
                    modelContext.insert(fourth)
                    modelContext.insert(user1)

                    user1.jobs.append(job1)
                    user1.jobs.append(job2)
                }
                Button("Add User", systemImage: "plus") {
                    var user = User()
                    modelContext.insert(user)
                    path = [user]
                }
                Button(showUpcomingOnly ? "All" : "Upcoming") {
                    withAnimation {
                        showUpcomingOnly.toggle()
                    }
                }
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by Name")
                            .tag([
                                SortDescriptor(\User.name),
                                SortDescriptor(\User.joinDate),
                            ])

                        Text("Sort by Join Date")
                            .tag([
                                SortDescriptor(\User.joinDate),
                                SortDescriptor(\User.name)
                            ])
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
