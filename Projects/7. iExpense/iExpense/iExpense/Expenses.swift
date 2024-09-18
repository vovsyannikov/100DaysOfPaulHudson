//
//  Expenses.swift
//  iExpense
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import Foundation
import Observation

@Observable
class Expenses {
	private let kItems = "Items"

	var items = [Item]() {
		didSet {
			if let encodedData = try? JSONEncoder().encode(items) {
				UserDefaults.standard.setValue(encodedData, forKey: kItems)
			}
		}
	}

	init() {
		guard let encodedData = UserDefaults.standard.data(forKey: kItems),
			  let decodedItems = try? JSONDecoder().decode([Item].self, from: encodedData)
		else { return }

		self.items = decodedItems
	}
}
