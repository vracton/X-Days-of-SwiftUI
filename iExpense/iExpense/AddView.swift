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
    let types: [String]
    
    @State private var name: String = "New Expense"
    @State private var amt: Double = 0.0
    @State private var type: String = "Personal"
    
    var body: some View {
        NavigationView {
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
            .navigationTitle($name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let expense = ExpenseItem(name: name, type: type, amount: amt)
                        expenses.items.insert(expense, at: 0)
                        dismiss()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AddView(expenses: Expenses(), types: ["Personal","Business"])
}
