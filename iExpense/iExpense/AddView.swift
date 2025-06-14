//
//  SwiftUIView.swift
//  iExpense
//
//  Created by vracto on 6/14/25.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    var expenses: Expenses
    
    @State private var name: String = ""
    @State private var amt: Double = 0.0
    @State private var type: String = "Personal"
    
    let types = ["Personal", "Business"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", value: $amt, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New Expense")
            .toolbar {
                Button("Add") {
                    let expense = ExpenseItem(name: name, type: type, amount: amt)
                    expenses.items.insert(expense, at: 0)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
