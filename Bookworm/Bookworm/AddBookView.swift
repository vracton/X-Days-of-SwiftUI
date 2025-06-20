//
//  AddBookView.swift
//  Bookworm
//
//  Created by vracto on 6/19/25.
//

import SwiftUI
import SwiftData

struct AddBookView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Query var books: [Book]
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = "Fantasy"
    @State private var review = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("General Details") {
                    TextField("Book Name", text: $title)
                    TextField("Author's Name", text: $author)
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Your Review") {
                    TextField("Review...", text: $review, axis: .vertical)
                        .lineLimit(3...)
                    RatingView(rating: $rating, label: "Rating", useSpacer: true)
                }
            }
            .navigationTitle("Add Book")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", systemImage: "checkmark") {
                        let newBook = Book(title: title.trimmed, author: author.trimmed, genre: genre, review: review, rating: rating)
                        modelContext.insert(newBook)
                        dismiss()
                    }
                    .disabled(title.trimmed.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddBookView()
}
