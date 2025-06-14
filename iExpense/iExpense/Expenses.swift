//
//  Expenses.swift
//  iExpense
//
//  Created by vracto on 6/13/25.
//

import SwiftUI

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "expenses")
            }
        }
    }
    
    init() {
        if let savedItemsData = UserDefaults.standard.data(forKey: "expenses") {
            if let savedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItemsData) {
                items = savedItems
                return
            }
        }
        
        items = []
    }
}
