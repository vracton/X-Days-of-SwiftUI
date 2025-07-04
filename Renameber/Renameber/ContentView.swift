//
//  ContentView.swift
//  Renameber
//
//  Created by vracto on 7/3/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var entries: [Entry]
    
    @State private var showingAdd = false
    
    var body: some View {
        NavigationStack {
            List(entries) { entry in
                Text(entry.name)
            }
            .navigationTitle("Renameber")
            .toolbar {
                Button("add", systemImage: "plus") {
                    showingAdd = true
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddView()
                    .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Entry.self)
}
