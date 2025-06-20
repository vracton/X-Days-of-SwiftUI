//
//  DetailView.swift
//  Bookworm
//
//  Created by vracto on 6/20/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    let book: Book
    
    @State private var showingDeleteAlert: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                ZStack(alignment: .bottom) {
                    Image(book.genre)
                        .resizable()
                        .scaledToFit()
                    
                    Text(book.genre.uppercased())
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundStyle(.white)
                        .background(.black.opacity(0.75))
                        .clipShape(.capsule)
                        .offset(x: 0, y: -5)
                }

                if !book.review.isEmpty {
                    Text("\"\(book.review)\"")
                        .font(.custom("BodoniSvtyTwoOSITCTT-BookIt", size: 30))
                        .padding()
                }

                RatingView(rating: .constant(book.rating))
                    .font(.largeTitle)
            }
            Text("Logged \(book.createdAt.formatted(date: .abbreviated, time: .shortened))")
                .font(.caption)
                .padding(.bottom)
        }
        .ignoresSafeArea()
        .navigationTitle(book.title)
        .navigationSubtitle(book.author)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Delete", systemImage: "trash", role: .destructive) {
                    showingDeleteAlert = true
                }
                .tint(.red)
            }
        }
        .alert("Delete Book",isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                modelContext.delete(book)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this book?")
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        let example = Book(title: "Test Book", author: "Test Author", genre: "Fantasy", review: "This was a great book; I really enjoyed it.", rating: 4)
        
        return DetailView(book: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
