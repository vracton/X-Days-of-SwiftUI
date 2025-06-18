//
//  ContentView.swift
//  Habits
//
//  Created by vracto on 6/17/25.
//

import SwiftUI

struct ContentView: View {
    @State private var activities: Activities = Activities()
    @State private var showingAddView: Bool = false
    
    func delete(at offsets: IndexSet) {
        activities.remove(atOffsets: offsets)
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($activities.activities) { $activity in
                    NavigationLink {
                        ActivityView(activity: $activity)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(activity.name)
                                    .font(.title2.bold())
                                if !activity.desc.isEmpty {
                                    Text(activity.desc.count < 15 ? activity.desc : "\(activity.desc.prefix(20).trimmingCharacters(in: .whitespacesAndNewlines))...")
                                        .font(.headline.weight(.medium))
                                }
                            }
                            Spacer()
                            Text("\(activity.count)")
                                .font(.title.weight(.semibold))
                                .monospaced()
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Habits")
            .toolbar {
                Button("Add", systemImage: "plus") {
                    showingAddView = true
                }
                EditButton()
            }
            .sheet(isPresented: $showingAddView) {
                AddActivity(activities: activities)
                    .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    ContentView()
}
