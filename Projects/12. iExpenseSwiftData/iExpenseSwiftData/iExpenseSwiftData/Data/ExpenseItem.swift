//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import Foundation
import SwiftData

@Model
class ExpenseItem {
	var name = ""

	@Attribute(originalName: "type")
	private var typeValue = ""

	var amount = 0.0

	var type: ExpenseType {
		get { ExpenseType(rawValue: typeValue) ?? .personal }
		set { typeValue = newValue.rawValue }
	}

	init(name: String = "", type: ExpenseType = .personal, amount: Double = 0.0) {
		self.name = name
		self.typeValue = type.rawValue
		self.amount = amount
	}

	static func predicate(for filter: ExpenseType) -> Predicate<ExpenseItem> {
		let filterValue = filter.rawValue
		return filter == .all
		? #Predicate { $0.typeValue != filterValue }
		: #Predicate { $0.typeValue == filterValue }
	}
}

// MARK: - ExpenseType
extension ExpenseItem {
	enum ExpenseType: String, CaseIterable, Codable, Identifiable {
		var id: RawValue { rawValue }

		case all = "Все"
		case personal = "Личная"
		case business = "Рабочая"

		var sectionName: String {
			switch self {
				case .business: "Рабочие траты"
				case .personal: "Личные траты"
				default: rawValue
			}
		}
	}
}

// MARK: - SampleData
extension ExpenseItem {
	@MainActor
	static func createPreviewContainer() throws -> ModelContainer {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)

		let container = try ModelContainer(for: ExpenseItem.self, configurations: config)

		let personalItem = ExpenseItem(name: "Тестовая трата", type: .personal, amount: 69)
		container.mainContext.insert(personalItem)

		let businessItem = ExpenseItem(name: "Тестовая трата по рабочим делам", type: .business, amount: 146)
		container.mainContext.insert(businessItem)

		let businessItem2 = ExpenseItem(name: "Вторая тестовая трата по рабочим делам", type: .business, amount: 6_000)
		container.mainContext.insert(businessItem2)

		return container
	}
}
