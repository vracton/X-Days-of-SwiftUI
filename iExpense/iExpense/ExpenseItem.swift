//
//  ExpenseItem.swift
//  iExpense
//
//  Created by vracto on 6/13/25.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
