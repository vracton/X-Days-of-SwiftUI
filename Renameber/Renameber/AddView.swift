//
//  AddView.swift
//  Renameber
//
//  Created by vracto on 7/3/25.
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imgData: Data?
    @State private var processedImg: Image?
    
    func loadImage() {
        Task {
            guard let selectedPhoto else { return }
            guard let data = try await selectedPhoto.loadTransferable(type: Data.self) else { return }
            imgData = data
            guard let inputImg = UIImage(data: data) else { return }
            processedImg = Image(uiImage: inputImg)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                TextField("Name", text: $name)
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    if let processedImg {
                        processedImg
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 16))
                    } else {
                        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import picture"))
                    }
                }
                .onChange(of: selectedPhoto, loadImage)
            }
            .navigationTitle("Add Entry")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("cancel", systemImage: "xmark", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("add", systemImage: "checkmark", role: .confirm) {
                        if name.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                            modelContext.insert(Entry(photo: imgData, name: name))
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AddView()
        .modelContainer(for: Entry.self)
}
