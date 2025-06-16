//
//  Theme.swift
//  Moonshot
//
//  Created by Sonit Sahoo on 6/14/25.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    static var darkBG: Color {
        Color(red: 0.1, green: 0.1, blue: 0.2)
    }

    static var lightBG: Color {
        Color(red: 0.2, green: 0.2, blue: 0.3)
    }
}


struct HorizDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundColor(.lightBG)
            .padding(.vertical)
    }
}

struct VertDivider: View {
    var body: some View {
        Rectangle()
            .frame(width: 2)
            .foregroundColor(.lightBG)
            .padding(.vertical)
    }
}
