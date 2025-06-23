//
//  ExpenseView.swift
//  iExpense
//
//  Created by vracto on 6/22/25.
//

import SwiftUI
import SwiftData

struct ExpenseView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [Expense]
    
    private let types: [String] = ContentView.types
    
    func removeExpense(at offsets: IndexSet) {
        for o in offsets {
            modelContext.delete(expenses[o])
        }
    }
    
    init(showPersonal: Bool, showBusiness: Bool, sortOrder: [SortDescriptor<Expense>]) {
        _expenses = Query(filter: #Predicate<Expense> { expense in
            if (showPersonal && expense.type == "Personal") || (showBusiness && expense.type == "Business") {
                return true
            } else {
                return false
            }
        }, sort: sortOrder)
    }
    
    var body: some View {
        List {
            ForEach(types, id: \.self) { type in
                if expenses.filter({$0.type==type}).count > 0 {
                    Section(type) {
                        ForEach(expenses) { item in
                            if item.type == type {
                                HStack {
                                    Text(item.name)
                                        .font(.headline)
                                    Spacer()
                                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .font(.title2)
                                        .fontWeight(item.amount < 10 ? .regular : (item.amount < 100 ? .semibold : .bold))
                                        .underline(item.amount > 100)
                                }
                            }
                        }
                        .onDelete(perform: removeExpense)
                    }
                }
            }
        }
    }
}

#Preview {
    ExpenseView(showPersonal: true, showBusiness: true, sortOrder: [
        SortDescriptor(\Expense.name),
        SortDescriptor(\Expense.amount, order: .reverse)
    ])
}
