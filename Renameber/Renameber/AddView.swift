//
//  AddView.swift
//  Renameber
//
//  Created by Sonit Sahoo on 7/3/25.
//

import SwiftUI
import PhotosUI

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        List {
            TextField("Name", text: $name)
            PhotosPicker("image",selection: $selectedPhoto)
                .buttonStyle(.plain)
        }
    }
}

#Preview {
    AddView()
}
