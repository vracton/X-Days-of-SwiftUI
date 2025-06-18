//
//  AddActivity.swift
//  Habits
//
//  Created by vracto on 6/17/25.
//

import SwiftUI

struct AddActivity: View {
    @Environment(\.dismiss) var dismiss
    
    var activities: Activities
    
    @State private var name: String = "New Activity"
    @State private var desc: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Activity Name", text: $name)
                TextField("Description", text: $desc,  axis: .vertical)
                    .lineLimit(5...)
            }
            .navigationTitle($name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", systemImage: "checkmark", role: .confirm) {
                        activities.add(Activity(name: name.trimmingCharacters(in: .whitespacesAndNewlines)
, desc: desc.trimmingCharacters(in: .whitespacesAndNewlines)
))
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines)
.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddActivity(activities: Activities())
}
