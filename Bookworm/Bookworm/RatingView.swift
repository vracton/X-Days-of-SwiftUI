//
//  RatingView.swift
//  Bookworm
//
//  Created by vracto on 6/19/25.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    
    var label: String = ""
    var maxRating: Int = 5
    var useSpacer: Bool = false
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            if !label.isEmpty {
                Text(label)
            }
            if useSpacer { Spacer() }
            ForEach(1...maxRating, id:\.self) { i in
                Button {
                    rating = i
                } label: {
                    if rating >= i {
                        onImage
                            .foregroundStyle(onColor)
                    } else {
                        Group {
                            offImage ?? Image(systemName: "star")
                        }
                        .foregroundStyle(offColor)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var rating = 3
    RatingView(rating: $rating, label: "rating")
}
