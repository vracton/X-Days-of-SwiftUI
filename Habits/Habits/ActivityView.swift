//
//  ActivityView.swift
//  Habits
//
//  Created by Sonit Sahoo on 6/17/25.
//

import SwiftUI

struct ActivityView: View {
    @Binding var activity: Activity
    
    @State private var showEditView = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(activity.count)")
                .font(.system(size: CGFloat(600/String(activity.count).count), weight: .bold))
                .monospaced()
            Spacer()
        }
        .navigationTitle(activity.name)
        .navigationSubtitle(activity.desc)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button("Edit", systemImage: "pencil") {
                    showEditView = true
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button("minus", systemImage: "minus") {
                    activity.count -= 1
                }
                .disabled(activity.count == 0)
                Button("plus", systemImage: "plus") {
                    activity.count += 1
                }
            }
        }
        .sheet(isPresented: $showEditView) {
            EditActivityView(activity: $activity)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    @Previewable @State var activity = Activity(name: "Running", desc: "Monday morning runs")
    
    ActivityView(activity: $activity)
}
