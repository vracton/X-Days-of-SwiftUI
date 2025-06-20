//
//  Book.swift
//  Bookworm
//
//  Created by vracto on 6/19/25.
//

import Foundation
import SwiftData

@Model
class Book {
    @Attribute(.unique) var id: UUID = UUID()
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int
    var createdAt: Date = Date.now
    
    init(title: String, author: String, genre: String, review: String, rating: Int) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
    }
}

extension String {
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
