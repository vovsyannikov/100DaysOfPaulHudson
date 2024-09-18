//
//  Order.swift
//  CupcakeCorner
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import Foundation

@Observable
final class Order: Codable {
	var type = CupcakeType.vanilla {
		didSet { save() }
	}

	var quantity = 3 {
		didSet { save() }
	}

	var specialRequestsEnabled = false {
		didSet {
			if !specialRequestsEnabled {
				extraFrosting = false
				addSprinkles = false
			}

			save()
		}
	}
	var extraFrosting = false {
		didSet { save() }
	}
	var addSprinkles = false {
		didSet { save() }
	}

	var name = "" {
		didSet { save() }
	}
	var streetAddress = "" {
		didSet { save() }
	}
	var city = "" {
		didSet { save() }
	}

	var hasValidAddress: Bool {
		let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
		let trimmedStreetAddress = streetAddress.trimmingCharacters(in: .whitespacesAndNewlines)
		let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)

		return (trimmedName.isEmpty || trimmedStreetAddress.isEmpty || trimmedCity.isEmpty) == false
	}

	var cost: Decimal {
		let quantity = Decimal(quantity)
		// 50₽ per cake
		var cost = quantity * 50

		// Complicated cakes cost more
		cost += Decimal(type.rawValue) * 10

		// 25₽/cake for extra frosting
		if extraFrosting {
			cost += quantity * 25
		}

		// 10₽/cake for sprinkles
		if addSprinkles {
			cost += quantity * 10
		}

		return cost
	}

	init() {
		guard 
			let data = UserDefaults.standard.data(forKey: "order"),
			let decodedData = try? JSONDecoder().decode(Order.self, from: data)
		else { return }

		self.type = decodedData.type
		self.quantity = decodedData.quantity

		self.specialRequestsEnabled = decodedData.specialRequestsEnabled
		self.extraFrosting = decodedData.extraFrosting
		self.addSprinkles = decodedData.addSprinkles

		self.name = decodedData.name
		self.streetAddress = decodedData.streetAddress
		self.city = decodedData.city
	}

	private func save() {
		let encodedData = try? JSONEncoder().encode(self)

		UserDefaults.standard.setValue(encodedData, forKey: "order")
	}
}

extension Order {
	enum CodingKeys: String, CodingKey {
		case _type = "type"
		case _quantity = "quantity"
		case _specialRequestsEnabled = "specialRequestsEnabled"
		case _extraFrosting = "extraFrosting"
		case _addSprinkles = "addSprinkles"
		case _name = "name"
		case _streetAddress = "streetAddress"
		case _city = "city"
	}
}

extension Order {
	enum CupcakeType: Int, CaseIterable, Codable, Identifiable {
		var id: RawValue { rawValue }

		case vanilla
		case strawberry
		case chocolate
		case rainbow

		var description: String {
			switch self {
				case .vanilla: 		"Ванильный"
				case .strawberry: 	"Клубничный"
				case .chocolate:	"Шоколадный"
				case .rainbow: 		"Радужный"
			}
		}
	}
}
