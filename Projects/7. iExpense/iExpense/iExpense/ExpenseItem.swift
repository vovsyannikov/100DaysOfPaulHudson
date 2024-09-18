//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import Foundation

extension Expenses {
	struct Item: Codable, Identifiable, Hashable {
		private(set) var id = UUID()

		let name: String
		let type: ExpenseType
		let amount: Double
	}
}

extension Expenses.Item {
	enum ExpenseType: String, CaseIterable, Codable {
		case personal = "Персональный"
		case business = "Бизнес"
	}
}
