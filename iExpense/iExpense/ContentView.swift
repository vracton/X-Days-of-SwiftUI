//
//  ContentView.swift
//  iExpense
//
//  Created by vracto on 6/11/25.
//

import SwiftUI

struct ContentView: View {
    let types = ["Personal", "Business"]
    
    @State private var expenses: Expenses = Expenses()
    
    func removeExpense(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(types, id: \.self) { type in
                    if expenses.items.filter({$0.type==type}).count > 0 {
                        Section(type) {
                            ForEach(expenses.items) { item in
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
            .navigationTitle(Text("iExpense"))
            .toolbar {
                NavigationLink(value: "AddView") {
                    Image(systemName: "plus")
                }
                EditButton()
            }
            .navigationDestination(for: String.self) { dest in
                if dest == "AddView" {
                    AddView(expenses: expenses, types: types)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
