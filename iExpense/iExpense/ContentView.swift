//
//  ContentView.swift
//  iExpense
//
//  Created by vracto on 6/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [Expense]
    
    static let types = ["Personal", "Business"]
    @State private var type = "Personal"
    @State private var showPersonal: Bool = true
    @State private var showBusiness: Bool = true
    @State private var sortOrder: [SortDescriptor<Expense>] = [
        SortDescriptor(\Expense.name),
        SortDescriptor(\Expense.amount, order: .reverse)
    ]
    var body: some View {
        NavigationStack {
            ExpenseView(showPersonal: showPersonal, showBusiness: showBusiness, sortOrder: sortOrder)
            .navigationTitle(Text("iExpense"))
            .toolbar {
                EditButton()
                NavigationLink(value: "AddView") {
                    Image(systemName: "plus")
                }
                Menu("More", systemImage: "ellipsis") {
                    Picker(selection: $sortOrder) {
                        Text("By Name").tag([
                            SortDescriptor(\Expense.name),
                            SortDescriptor(\Expense.amount, order: .reverse)
                        ])
                        Text("By Amount").tag([
                            SortDescriptor(\Expense.amount, order: .reverse),
                            SortDescriptor(\Expense.name)
                        ])
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                        Text("Sort")
                        Text(sortOrder[0].keyPath == \Expense.name ? "By Name" : "By Amount")
                    }
                    .pickerStyle(.menu)
                    Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                        Button {
                            showPersonal.toggle()
                        } label: {
                            Image(systemName: showPersonal ? "checkmark" : "")
                            Text("Personal")
                        }
                        Button {
                            showBusiness.toggle()
                        } label: {
                            Image(systemName: showBusiness ? "checkmark" : "")
                            Text("Business")
                        }
                    }
                }
            }
            .navigationDestination(for: String.self) { dest in
                if dest == "AddView" {
                    AddView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Expense.self)
}
