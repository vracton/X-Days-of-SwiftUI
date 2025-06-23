//
//  Expense.swift
//  iExpense
//
//  Created by vracto on 6/13/25.
//

import SwiftUI
import SwiftData

@Model
class Expense: Identifiable {
    @Attribute(.unique) var id = UUID()
    var name: String
    var type: String
    var amount: Double
    
    init(id: UUID = UUID(), name: String, type: String, amount: Double) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
    }
}
