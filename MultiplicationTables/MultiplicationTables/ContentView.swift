//
//  ContentView.swift
//  MultiplicationTables
//
//  Created by vracto on 6/8/25.
//

import SwiftUI

struct DefaultButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .font(.system(size: 20))
    }
}

extension View {
    func defaultButton() -> some View {
        modifier(DefaultButtonStyle())
    }
}

struct StartView: View {
    @Binding var tableNumber: Int
    @Binding var numQuestions: Int
    
    @State var startFunc: () -> Void
    
    let questionCounts: [Int] = [5,10,15,20]
    
    var body: some View {
        VStack {
            Text("Multiplication Quiz")
                .font(.title.bold())
            Spacer()
                .frame(height:15)
            VStack {
                Stepper("**\(tableNumber)** Times Table",value: $tableNumber, in: 1...20)
                HStack {
                    Picker("Number of Questions", selection: $numQuestions) {
                        ForEach(questionCounts, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.segmented)
                    Text("Problems")
                }
            }
            .padding()
            Button("Play!") {
                startFunc()
            }
            .defaultButton()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 16))
        .padding()
    }
}

struct QuestionView: View {
    @Binding var q: Question
    @State var nextQFunc: () -> Void
    
    var body: some View {
        VStack {
            Text("Problem #\(q.qID+1)")
                .font(.title2.bold())
                .foregroundStyle(.secondary)
            Text("\(q.multiplicand) \u{00d7} \(q.multiplier) =")
                .font(.largeTitle.bold())
            HStack {
                Image(systemName: "number")
                TextField(" ", value: $q.userAnswer, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                Button("Submit") {
                    nextQFunc()
                }
                .buttonStyle(.bordered)
                .font(.system(size: 20))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 16))
        .padding()
        .transition(.opacity)
    }
}

struct EndView: View {
    @Binding var numCorrect: Int
    @Binding var numQuestions: Int
    
    @State var replayFunc: (Bool) -> Void
    
    var body: some View {
        VStack {
            Text("All done!")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("\(numCorrect)/\(numQuestions) - \(String(format: "%.2f", Double(numCorrect)/Double(numQuestions)*100))%")
                .font(.largeTitle.bold())
            Text(numCorrect > 7/10*numQuestions ? "Good job!" : "Better luck next time!")
                .font(.title2.bold())
            HStack {
                Button("Retry") {
                    replayFunc(true)
                }
                .buttonStyle(.bordered)
                .font(.system(size: 20))
                Button("New Quiz") {
                    replayFunc(false)
                }
                .defaultButton()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 16))
        .padding()
        .transition(.scale)
    }
}

struct Question {
    var multiplicand: Int
    var multiplier: Int
    var userAnswer: Int
    var qID: Int
}

struct ContentView: View {
    @State private var gameState: Int = 0 //0=start, 1=play, 2=end screen
    @State private var tableNumber: Int = 2
    @State private var numQuestions: Int = 10
    
    @State private var questions: [Question] = [Question]()
    @State private var curQuestion: Int = 0
    
    func startGame() {
        for i in 0..<numQuestions {
            questions.append(Question(multiplicand: tableNumber, multiplier: Int.random(in: 1...20), userAnswer: 0, qID: i))
        }
        withAnimation {
            gameState = 1
        }
    }
    
    @State private var numCorrect: Int = 0
    func nextQ() {
        withAnimation {
            curQuestion += 1
        }
        if curQuestion == numQuestions {
            withAnimation {
                gameState = 2
            }
            for q in questions {
                if q.userAnswer == q.multiplicand * q.multiplier {
                    numCorrect += 1
                }
            }
        }
    }
    
    func replay(_ preserveQuestions: Bool = false) {
        curQuestion = 0
        if !preserveQuestions {
            questions = [Question]()
            withAnimation {
                gameState = 0
            }
        } else {
            for i in 0..<numQuestions {
                questions[i].userAnswer = 0
            }
            withAnimation {
                gameState = 1
            }
        }
    }
    
    var body: some View {
        ZStack {
            if gameState == 0 {
                Color(red: 137/255, green: 220/255, blue: 235/255)
            } else if gameState == 1 {
                Color(red: 245/255, green: 224/255, blue: 220/255)
            } else if gameState == 2 {
                if numCorrect > 7/10*numQuestions {
                    Color(red: 166/255, green: 227/255, blue: 161/255)
                } else {
                    Color(red: 235/255, green: 160/255, blue: 172/255)
                }
            }
            if gameState == 0 {
                StartView(tableNumber: $tableNumber, numQuestions: $numQuestions, startFunc: startGame)
            } else if gameState == 1 {
                ForEach($questions, id: \.qID){ $question in
                    if question.qID == curQuestion {
                        QuestionView(q: $question, nextQFunc: nextQ)
                    }
                }
            } else if gameState == 2 {
                EndView(numCorrect: $numCorrect, numQuestions: $numQuestions, replayFunc: replay)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
