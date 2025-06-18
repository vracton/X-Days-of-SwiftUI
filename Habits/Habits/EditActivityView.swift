//
//  EditActivityView.swift
//  Habits
//
//  Created by vracto on 6/17/25.
//

import SwiftUI

struct EditActivityView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var activity: Activity
    
    @State private var origName: String = ""
    @State private var newName: String = ""
    @State private var newDesc: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Activity Name", text: $newName)
                TextField("Description", text: $newDesc,  axis: .vertical)
                    .lineLimit(5...)
            }
            .navigationTitle("Edit \(origName)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", systemImage: "checkmark", role: .confirm) {
                        activity.name = newName.trimmingCharacters(in: .whitespacesAndNewlines)
                        activity.desc = newDesc.trimmingCharacters(in: .whitespacesAndNewlines)
                        dismiss()
                    }
                    .disabled(newName.trimmingCharacters(in: .whitespacesAndNewlines)
.isEmpty)
                }
            }
            .onAppear() {
                origName = activity.name
                newName = activity.name
                newDesc = activity.desc
            }
        }
    }
}

#Preview {
    @Previewable @State var activity = Activity(name: "Running", desc: "Monday morning runs")
    
    EditActivityView(activity: $activity)
}
