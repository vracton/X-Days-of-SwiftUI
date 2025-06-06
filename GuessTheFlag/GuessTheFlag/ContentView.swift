//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Sonit Sahoo on 6/2/25.
//

import SwiftUI

struct FlagImage: View {
    let image: String
    
    var body: some View {
        Image(image)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(radius: 5)
    }
}

struct GlassBG: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 16))
    }
}

extension View {
    func glassBG() -> some View {
        modifier(GlassBG())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correct = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreText = ""
    @State private var numQs = 0
    @State private var numCorrect = 0
    
    @State private var chosen = 0
    func flagClicked(_ n: Int) {
        numQs+=1
        chosen = n
        if n == correct {
            scoreText = "Correct"
            numCorrect+=1
        } else {
            scoreText = "Incorrect"
        }
        
        showingScore = true
    }
    
    func nextTurn() {
        if numQs == 8 {
            numQs=0
            numCorrect=0
        }
        countries.shuffle()
        correct = Int.random(in: 0...2)
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .blue.opacity(0.85), location: 0.3),
                .init(color: .red.opacity(0.85), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 250)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .foregroundStyle(.white.opacity(0.9))
                    .font(.largeTitle.bold())
                Text("\(numCorrect)/\(min(numQs, 8)) Correct")
                    .foregroundStyle(.white.opacity(0.9))
                    .font(.title.bold())
                Spacer()
                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Choose the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correct])

                            .font(.largeTitle.weight(.heavy))
                    }
                    
                    ForEach(0..<3) { n in
                        Button {
                            flagClicked(n)
                        } label: {
                            FlagImage(image: countries[n])
                        }
                    }
                }
                .glassBG()
                Spacer()
                Spacer()
            }
            .padding()
        }
        .alert(numQs<8 ? scoreText:"Game Over", isPresented: $showingScore) {
            Button(numQs<8 ? "Next" : "Replay", action: nextTurn)
        } message: {
            Text(numQs<8 ? "That was the flag of \(countries[chosen])!":"Your final score is \(numCorrect)/8!")
        }
    }
}

#Preview {
    ContentView()
}
