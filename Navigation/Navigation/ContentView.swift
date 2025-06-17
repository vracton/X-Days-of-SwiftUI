 //
//  ContentView.swift
//  Navigation
//
//  Created by vracto on 6/16/25.
//

import SwiftUI

struct DetailView: View {
    var number: Int
    @Binding var path: NavigationPath
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: CGFloat(10*String(number).count)))]) {
                ForEach(0..<666) { n in
                    Text("\(number)")
                }
                .monospaced()
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("\(number)")
        //.toolbarBackground(.brown)
        .toolbar {
            ToolbarSpacer(.flexible, placement: .bottomBar)
            ToolbarItemGroup(placement: .bottomBar) {
                NavigationLink("random", value: Int.random(in: 1..<1000))
                Button("reset") {
                    path = NavigationPath()
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var pathStore: PathStore = PathStore()

    var body: some View {
        NavigationStack(path: $pathStore.path) {
            DetailView(number: 0, path: $pathStore.path)
                .navigationDestination(for: Int.self) { i in
                    DetailView(number: i, path: $pathStore.path)
                }
        }
    }
}

#Preview {
    ContentView()
}
