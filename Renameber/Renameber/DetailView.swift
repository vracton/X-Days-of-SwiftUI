//
//  DetailView.swift
//  Renameber
//
//  Created by vracto on 7/23/25.
//

import SwiftUI

struct DetailView: View {
    let entry: Entry
    
    var body: some View {
        imageView(for: entry.photo)
            .resizable()
            .scaledToFit()
            .clipShape(.rect(cornerRadius: 16))
            .padding()
        .navigationTitle(entry.name)
    }
}

#Preview {
    DetailView(entry: Entry(photo: nil, name: "John Doe"))
}
