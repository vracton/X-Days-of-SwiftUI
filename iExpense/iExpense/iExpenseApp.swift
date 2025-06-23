//
//  iExpenseApp.swift
//  iExpense
//
//  Created by vracto on 6/11/25.
//

import SwiftUI
import SwiftData

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Expense.self)
    }
}
