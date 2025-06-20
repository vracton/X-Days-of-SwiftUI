//
//  ContentView.swift
//  Bookworm
//
//  Created by vracto on 6/19/25.
//

import SwiftUI
import SwiftData

//didnt do challenge 2 because i feel like 1 stars are already signified by the emoji, so more effects would be weird

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [
        SortDescriptor(\Book.title),
        SortDescriptor(\Book.author),
        SortDescriptor(\Book.rating, order: .reverse)
    ]) var books: [Book]
    
    @State private var showingAddView: Bool = false
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(books[offset])
        }
    }
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)

                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                if !book.author.isEmpty {
                                    Text(book.author)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .toolbar {
                Button("Add Book", systemImage: "plus") {
                    showingAddView = true
                }
                EditButton()
            }
            .sheet(isPresented: $showingAddView) {
                AddBookView()
            }
            .navigationTitle("Bookworm")
            .navigationSubtitle("^[\(books.count) book](inflect: true) saved")
            .navigationDestination(for: Book.self) { book in
                DetailView(book: book)
            }
        }
    }
}

#Preview {
    ContentView()
}
