//
//  ContentView.swift
//  WordScramble
//
//  Created by vracto on 6/6/25.
//

import SwiftUI

struct ContentView: View {
    @State private var used: [String] = [String]()
    @State private var root: String = ""
    @State private var newWord: String = ""
    
    @State private var wordErrorDesc: String = ""
    @State private var showWordError: Bool = false
    
    var score: Int {
        var scoreTracker = 0
        for word in used {
            scoreTracker += 50 + word.count*50
        }
        return scoreTracker
    }
    
    func isValid(_ word: String) -> Bool {
        //check if word is same as root
        wordErrorDesc = "You can't use the same word..."
        if word == root {
            return false
        }
        
        //check if too short
        wordErrorDesc = "Your word must be at least 3 letters long!"
        if word.count < 3 {
            return false
        }
        
        //check if used
        wordErrorDesc = "You've already used that word!"
        if used.contains(word) {
            return false
        }
        
        //check if characters are possible
        wordErrorDesc = "The root word doesn't have those letters!"
        var check = root
        for char in word {
            guard let i = check.firstIndex(of: char) else {
                return false
            }
            check.remove(at: i)
        }
        
        //check if real word
        wordErrorDesc = "That's not a real word..."
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let res = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return res.location == NSNotFound
    }
    
    func addNewWord() {
        let fWord = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard fWord.count > 0 else { return }
        guard isValid(fWord) else {
            showWordError = true
            return
        }
        withAnimation {
            used.insert(fWord, at: 0)
        }
        newWord = ""
    }
    
    func setWord() {
        if let wordsFileUrl = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let content = try? String(contentsOf: wordsFileUrl, encoding: .ascii) {
                root = content.components(separatedBy: .newlines).randomElement() ?? "aardvark"
                return
            }
        }
        
        fatalError("Could not load words.txt from bundle.")
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter a Word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                Section {
                    HStack(spacing: 0) {
                        withAnimation {
                            Text("\(score)")
                                .font(.title.bold())
                        }
                        VStack {
                            Spacer()
                            Spacer()
                            Text("points")
                                .font(.caption)
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Section {
                    ForEach(used, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle.fill")
                            Text(word)
                        }
                        .accessibilityElement()
                        .accessibilityLabel("\(word), \(word.count) letters")
                    }
                }
                
            }
            .navigationTitle(root)
            .onSubmit(addNewWord)
            .toolbar {
                Button("New Word") {
                    setWord()
                    newWord = ""
                    withAnimation {
                        used = []
                    }
                }
            }
        }
        .onAppear(perform: setWord)
        .alert("Invalid Word", isPresented: $showWordError) {
            Button("Got it") {}
        } message: {
            Text(wordErrorDesc)
        }
    }
}

#Preview {
    ContentView()
}
