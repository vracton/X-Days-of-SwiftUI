//
//  ContentView.swift
//  BetterRest
//
//  Created by vracto on 6/5/25.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var sleepAmt: Double = 8.0
    @State private var coffeeAmt: Int = 1
    @State private var wakeUpTime: Date = defaultWakeTime
    
    @State private var showCalcMsg: Bool = false
    @State private var calcTitle: String = ""
    @State private var calcDesc: String = ""
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    @State private var sleepTime: Date = defaultWakeTime
    func calcBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalc(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let hours = (components.hour ?? 0)*60*60
            let mins = (components.minute ?? 0)*60
            
            let prediction = try model.prediction(wake: Double(hours+mins), estimatedSleep: sleepAmt, coffee: Double(coffeeAmt))
            sleepTime = wakeUpTime - prediction.actualSleep
            
            calcTitle = "Results are in!"
            calcDesc = "You should go to bed at \(sleepTime.formatted(date: .omitted, time: .shortened))"
        } catch {
            calcTitle = "Error!"
            calcDesc = "You may need to visit a doctor..."
        }
        //showCalcMsg = true
    }
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Wake Up Time")
                        .font(.headline)
                    DatePicker("Time: ", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .onChange(of: wakeUpTime) { calcBedTime() }
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Wanted Amount of Sleep")
                        .font(.headline)
                    Stepper("\(sleepAmt.formatted()) hours", value: $sleepAmt, in: 4...12, step: 0.25)
                        .onChange(of: sleepAmt) { calcBedTime() }
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily Coffee Consumption")
                        .font(.headline)
                    Picker("^[\(coffeeAmt) cup](inflect: true)", selection: $coffeeAmt) {
                        ForEach (0...20, id: \.self) {
                            Text("^[\($0) cup](inflect: true)")
                        }
                    }
                    .pickerStyle(.wheel)
                    .onChange(of: coffeeAmt) { calcBedTime() }
                }
                
                Section {
                    VStack {
                        Text("You should go to bed at")
                            .font(.title3)
                        Text("\(sleepTime.formatted(date: .omitted, time: .shortened))")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("BetterRest")
            //.toolbar {
            //    Button("Calculate", action: calcBedTime)
            //}
            .alert(calcTitle, isPresented: $showCalcMsg) {
                Button("Thanks!"){}
            } message: {
                Text(calcDesc)
            }
        }.onAppear(perform: calcBedTime)
    }
}

#Preview {
    ContentView()
}
