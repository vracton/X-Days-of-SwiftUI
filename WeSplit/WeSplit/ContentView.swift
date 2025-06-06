import SwiftUI

struct ContentView: View {
    @State private var total: Double = 0;
    @State private var numPeople: Int = 0;
    @State private var tip = 10;
    
    @FocusState private var totalFocused: Bool;
    
    let tips = [0,10,15,20,25]
    
    var tipAmount: Double {
        return total * Double(tip) / 100;
    }
    
    var totalWithTip: Double {
        return total+tipAmount;
    }
    
    var totalPerPerson: Double {
        return totalWithTip / Double(numPeople+2);
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Amount", value: $total, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($totalFocused)
                    
                    Picker("Number of People", selection: $numPeople) {
                        ForEach(2..<100){
                            Text("\($0) people")
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section("Tip Percent") {
                    Picker("Tip %", selection: $tip){
                        ForEach(tips, id: \.self){
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Total Bill") {
                    Text(total, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    Text(tipAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundStyle(tip==0 ? .secondary : .primary)
                    Text(totalWithTip, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                
                Section("Amount per Person") {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if totalFocused {
                    Button("Done") {
                        totalFocused = false;
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
