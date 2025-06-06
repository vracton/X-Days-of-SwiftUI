//
//  ContentView.swift
//  RockPaperScissorsTrainer
//
//  Created by Sonit Sahoo on 6/4/25.
//

import SwiftUI

extension Bool {
    func toInt() -> Int {
        return self ? 1 : 0
    }
}

struct MoveButton: View {
    let move: String
    let emoji: String
    let action: (String) -> Void
    
    var body: some View {
        Button {
            action(move)
        } label: {
           Text(emoji)
                .rotationEffect(Angle(degrees: move=="scissors" ? -90 : 0))
        }
        .font(.system(size: 75))
    }
}

struct ContentView: View {
    let moves = ["rock", "paper", "scissors"]
    let moveEmojis = ["🪨","📄","✂️"]
    
    @State private var curMove: Int = Int.random(in: 0...2)
    @State private var shouldWin: Bool = Bool.random()
    @State private var score: Int = 0
    @State private var numRounds: Int = 0
    @State private var showEnd: Bool = false
    
    func nextTurn(_ move: String) {
        guard let moveNum: Int = moves.firstIndex(of: move) else { return }
        
        if moveNum == ((curMove+(2*shouldWin.toInt()-1)+3)%3) {
            score+=1;
        } else {
            score-=1;
        }
        
        numRounds+=1;
        
        if numRounds < 10 {
            curMove = Int.random(in: 0...2)
            shouldWin = Bool.random()
        } else {
            showEnd = true
        }
    }
    
    func restart() {
        numRounds = 0
        score = 0
        curMove = Int.random(in: 0...2)
        shouldWin = Bool.random()
    }
    
    var body: some View {
        ZStack {
            //rgb(30, 30, 46)
            //rgb(24, 24, 37)
            //rgb(180, 190, 254)
            LinearGradient(stops: [
                .init(color: Color(red: 137/255, green: 180/255, blue: 250/255), location: 0),
                .init(color: Color(red: 17/255, green: 17/255, blue: 34/255), location: 1),
            ], startPoint: .top, endPoint: .bottom)
            
            VStack {
                Spacer(minLength: 100)
                VStack {
                    Text("Rock Paper Scissors Trainer")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Score: \(score)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                Spacer()
                Spacer()
                VStack(spacing: 15) {
                    VStack {
                        Text("\(moves[curMove])")
                            .foregroundStyle(.secondary)
                            .font(.largeTitle)
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                        Text("\(shouldWin ? "Win" : "Lose")")
                            .foregroundStyle(shouldWin ? Color(red: 166/255, green:227/255, blue:161/255) : Color(red: 235/255, green: 160/255, blue: 172/255))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    ForEach (0..<3) { i in
                        MoveButton(move: moves[i], emoji: moveEmojis[i], action: nextTurn)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 16))
                .padding()
                Spacer()
                Spacer()
            }
        }
        .ignoresSafeArea()
        
        .alert("Game Over!", isPresented: $showEnd) {
            Button("Replay") {
                restart()
            }
        } message: {
            Text("Your final score was \(score). \(score < 0 ? "Lock in." : (score <  10 ? "Keep trying." : "orz"))")
        }
    }
}

#Preview {
    ContentView()
}
