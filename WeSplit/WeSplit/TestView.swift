//
//  ContentView.swift
//  WeSplit
//
//  Created by Sonit Sahoo on 5/31/25.
//

import SwiftUI

struct TestView: View {
    let colors = ["red", "green", "blue", "yellow", "orange"]
    @State var chosenColor = "red"
    @State var tapCount = 0
    @State var name = "";
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("hi \(name)")
                    TextField("Enter your name", text: $name)
                }
                
                Section {
                    Text("you like \(chosenColor)")
                    Picker("whats your favorite color", selection: $chosenColor) {
                        ForEach(colors, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Button("you tapped \(tapCount) times") {
                    self.tapCount += 1
                }
            }
            .navigationTitle("WeSplit")
            //.navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    TestView()
}
