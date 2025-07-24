//
//  ContentView.swift
//  Renameber
//
//  Created by vracto on 7/3/25.
//

import SwiftUI
import SwiftData

func imageView(for data: Data?) -> Image {
    if let uwData = data {
        guard let inputImg = UIImage(data: uwData) else { return Image(systemName: "person.fill") }
        return Image(uiImage: inputImg)
    } else {
        return Image(systemName: "person.fill")
    }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: [
        SortDescriptor(\Entry.name, order: .forward)
    ]) var entries: [Entry]
    
    @State private var showingAdd = false
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(entries[offset])
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(entries) { entry in
                    NavigationLink(value: entry) {
                        HStack {
                            imageView(for: entry.photo)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                            Text(entry.name)
                                .font(.title2)
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Renameber")
            .navigationSubtitle("\(entries.count) \(entries.count==1 ?"entry":"entries") saved")
            .toolbar {
                Button("add", systemImage: "plus") {
                    showingAdd = true
                }
                EditButton()
            }
            .sheet(isPresented: $showingAdd) {
                AddView()
                    .presentationDetents([.medium])
            }
            .navigationDestination(for: Entry.self) { entry in
                DetailView(entry: entry)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Entry.self)
}
