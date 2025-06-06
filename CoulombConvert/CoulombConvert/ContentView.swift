//
//  ContentView.swift
//  CoulombConvert
//
//  Created by Sonit Sahoo on 6/1/25.
//

import SwiftUI

extension Formatter {
    static let scientific: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.exponentSymbol = "\u{00d7}10^"
        return formatter
    }()
}

extension Numeric {
    var scientific: String {
        return Formatter.scientific.string(for: self) ?? ""
    }
}

struct ContentView: View {
    let units: [String] = ["C","mC","\u{03bc}C","nC","pC"]
    
    @State private var val: Double = 1.0
    @State private var selectStart: String = "C";
    @State private var selectEnd: String = "nC"
    
    var convertedVal: Double {
        guard let startIndex = units.firstIndex(of: selectStart),
              let endIndex = units.firstIndex(of: selectEnd)
        else { return 0.0 }
        
        return val*pow(10, Double(startIndex - endIndex)*3)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Value") {
                    TextField("Value", value: $val, format: .number)
                }
                
                Section {
                    Picker("Start Unit", selection: $selectStart) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    HStack {
                        Spacer()
                        Button {
                            (selectStart, selectEnd) = (selectEnd, selectStart)
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                        .foregroundStyle(.gray)
                        .tint(.mint)
                        Spacer()
                    }
                    
                    Picker("End Unit", selection: $selectEnd) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("converted"){
                    Text("\(convertedVal.scientific) \(selectEnd)")
                }
            }
            .navigationTitle(Text("CoulombConvert"))
        }
    }
}

#Preview {
    ContentView()
}
