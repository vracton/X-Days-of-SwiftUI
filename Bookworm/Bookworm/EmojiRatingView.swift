//
//  EmojiRatingView.swift
//  Bookworm
//
//  Created by vracto on 6/19/25.
//

import SwiftUI

struct EmojiRatingView: View {
    let rating: Int
    var body: some View {
        switch rating {
        case 1:
            Text("🤮")
        case 2:
            Text("😕")
        case 3:
            Text("😐")
        case 4:
            Text("🙂")
        default:
            Text("😃")
        }
//        ZStack {
//            Image(systemName: "star.fill")
//                .foregroundStyle(.yellow)
//                .font(.system(size: 32))
//
//            Text("\(rating)")
//                .foregroundStyle(.white)
//                .font(.system(size: 18).bold())
//        }
    }
}

#Preview {
    EmojiRatingView(rating: 1)
}
