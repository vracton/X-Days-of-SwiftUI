//
//  Users.swift
//  SwiftDataTest
//
//  Created by vracto on 6/22/25.
//

import SwiftUI
import SwiftData


struct UsersView: View {
    @Query var users: [User]
    
    init(minJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
        _users = Query(filter: #Predicate<User> { user in
            user.joinDate >= minJoinDate
        }, sort: sortOrder)
    }
    
    var body: some View {
        List(users) { user in
            NavigationLink(value: user) {
                HStack {
                        Text(user.name)
                        Spacer()
                        Text("\(user.jobs.count)")
                            .fontWeight(.black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.blue)
                            .foregroundStyle(.white)
                            .clipShape(.capsule)
                    }
            }
        }
        .navigationTitle("Users")
        .navigationDestination(for: User.self) { user in
            EditUserView(user: user)
        }
    }
}

#Preview {
    UsersView(minJoinDate: .now, sortOrder: [SortDescriptor(\User.name)])
        .modelContainer(for: User.self)
}
