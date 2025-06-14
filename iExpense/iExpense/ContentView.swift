//
//  ContentView.swift
//  iExpense
//
//  Created by vracto on 6/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAddView: Bool = false
    
    @State private var expenses: Expenses = Expenses()
    
    func removeExpense(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationStack {
            List {
                if expenses.items.filter({$0.type=="Personal"}).count > 0 {
                    Section("Personal") {
                        ForEach(expenses.items) { item in
                            if item.type == "Personal" {
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
                
                if expenses.items.filter({$0.type=="Business"}).count > 0 {
                    Section("Business") {
                        ForEach(expenses.items) { item in
                            if item.type == "Business" {
                                HStack {
                                    Text(item.name)
                                        .font(.headline)
                                    Spacer()
                                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .font(.title2)
                                }
                            }
                        }
                        .onDelete(perform: removeExpense)
                    }
                }
            }
            .navigationTitle(Text("iExpense"))
            .toolbar {
                Button("add test", systemImage: "plus") {
                    showingAddView = true
                }
                EditButton()
            }
        }
        .sheet(isPresented: $showingAddView) {
            AddView(expenses: expenses)
        }
    }
}

#Preview {
    ContentView()
}
