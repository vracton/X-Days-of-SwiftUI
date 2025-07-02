//
//  ContentView.swift
//  AccessibilitySandbox
//
//  Created by vracto on 7/2/25.
//

import SwiftUI

struct ContentView: View {
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096",
        "character"
    ]
    
    let labels = [
        "Tulips",
        "Frozen tree buds",
        "Sunflowers",
        "Fireworks",
        "Character"
    ]

    @State private var selectedPicture = Int.random(in: 0...4)
    @State private var value = 10

    var body: some View {
        VStack {
            Text("Value: \(value)")

            Button("Increment") {
                value += 1
            }

            Button("Decrement") {
                value -= 1
            }
        }
        .accessibilityElement()
        .accessibilityLabel("value")
        .accessibilityValue(String(value))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                value+=1
            case .decrement:
                value-=1
            default:
                print("couldnt handle")
            }
        }
        VStack {
            Text("you are cool")
            Text("name")
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("your are cool name")
        //.combine adds a pause
        
        Button {
            selectedPicture = Int.random(in: 0...4)
        } label: {
            Image(pictures[selectedPicture])
                .resizable()
                .scaledToFit()
        }
        .accessibilityLabel(labels[selectedPicture])
    }
}

#Preview {
    ContentView()
}
