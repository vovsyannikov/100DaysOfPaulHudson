//
//  Units.swift
//  UnitConverter
//
//  Created by Виталий Овсянников on 02.07.2024.
//

enum Converter: String, CaseIterable, Identifiable {
	var id: String { rawValue }

	case temperature = "Температура"
	case distance = "Расстояние"
	case time = "Время"
	case volume = "Объём"
}

protocol Measurement: RawRepresentable, Hashable, CaseIterable, Identifiable {
	var symbol: String { get }

	static func rest(of value: Self) -> [Self]

	func convertValue(_ value: Double, of unit: Self) -> Double
}

extension Measurement {
	var id: RawValue { rawValue }
	static var first: Self { allCases[0 as! Self.AllCases.Index] }


	func conversionRate(for value: Self) -> String {
		let input = "1 \(self.symbol)"
		let outputValue = self.convertValue(1, of: value)
		let output = "\(outputValue) \(value.symbol)"

		return [input, output].joined(separator: " ≈ ")
	}
}

extension Converter {
	// MARK: - Temperature
	enum Temperature: String, Measurement {
		case celsius = "Цельсий"
		case fahrenheit = "Фаренгейт"
		case kelvin = "Кельвин"

		var symbol: String {
			switch self {
				case .celsius: return "Cº"
				case .fahrenheit: return "Fº"
				case .kelvin: return "Kº"
			}
		}

		static func rest(of value: Temperature) -> [Temperature] {
			switch value {
				case .celsius: return [.fahrenheit, .kelvin]
				case .fahrenheit: return [.celsius, .kelvin]
				case .kelvin: return [.celsius, .fahrenheit]
			}
		}

		func convertValue(_ value: Double, of unit: Temperature) -> Double {
			switch (self, unit) {
				case (.celsius, .fahrenheit):
					return value * 9 / 5 + 32
					
				case (.celsius, .kelvin):
					return value + 273.15
					
				case (.fahrenheit, .celsius):
					return (value - 32) * 5 / 9
					
				case (.kelvin, .celsius):
					return value - 273.15
					
				case (.fahrenheit, .kelvin):
					return ((value - 32) * 5 / 9) + 273.15
					
				case (.kelvin, .fahrenheit):
					return (value - 273.15) * 9 / 5 + 32
					
				default:
					return value
			}
		}
	}

	// MARK: - Distance
	enum Distance: String, Measurement {
		case meters = "Метры"
		case kilometers = "Километры"
		case feet = "Футы"
		case yards = "Ярды"
		case miles = "Мили"

		var symbol: String {
			switch self {
				case .meters: return "м"
				case .kilometers: return "км"
				case .feet: return "футы"
				case .yards: return "ярд"
				case .miles: return "мили"
			}
		}

		static func rest(of value: Distance) -> [Distance] {
			switch value {
				case .meters: return [.kilometers, .feet, .yards, .miles]
				case .kilometers: return [.meters, .feet, .yards, .miles]
				case .feet: return [.meters, .kilometers, .yards, .miles]
				case .yards: return [.meters, .kilometers, .feet, .miles]
				case .miles: return [.meters, .kilometers, .feet, .yards]
			}
		}

		func convertValue(_ value: Double, of unit: Distance) -> Double {
			switch (self, unit) {
				case (.meters, .kilometers):
					return value / 1_000

				case (.meters, .feet):
					return value * 3.28084

				case (.meters, .yards):
					return value / 0.9144

				case (.meters, .miles):
					return value * 0.000621

				case (.kilometers, .meters):
					return value * 1_000

				case (.kilometers, .feet):
					return value * 3_280.84

				case (.kilometers, .yards):
					return value / 0.0009144

				case (.kilometers, .miles):
					return value * 0.621371

				case (.feet, .meters):
					return value * 0.3048

				case (.feet, .kilometers):
					return value * 0.3048 / 1_000

				case (.feet, .yards):
					return value / 3

				case (.feet, .miles):
					return value / 5280

				case (.yards, .meters):
					return value * 0.9144

				case (.yards, .kilometers):
					return value * 0.0009144

				case (.yards, .feet):
					return value * 3

				case (.yards, .miles):
					return value * 0.00056818

				case (.miles, .meters):
					return value / 0.00062137119223733

				case (.miles, .kilometers):
					return value * 1.609344

				case (.miles, .feet):
					return value * 5_280

				case (.miles, .yards):
					return value * 1_760

				default:
					return value
			}
		}
	}

	// MARK: - Time
	enum Time: String, Measurement {
		case days = "Дни"
		case hours = "Часы"
		case minutes = "Минуты"
		case seconds = "Секунды"

		var symbol: String {
			switch self {
				case .days: return "д"
				case .hours: return "ч"
				case .minutes: return "мин"
				case .seconds: return "сек"
			}
		}

		static func rest(of value: Time) -> [Time] {
			switch value {
				case .days: return [.hours, .minutes, .seconds]
				case .hours: return [.days, .minutes, .seconds]
				case .minutes: return [.days, .hours, .seconds]
				case .seconds: return [.days, .hours, .minutes]
			}
		}

		func convertValue(_ value: Double, of unit: Time) -> Double {
			switch (self, unit) {
				case (.days, .hours):
					return value * 24

				case (.days, .minutes):
					return value * 24 * 60

				case (.days, .seconds):
					return value * 24 * 60 * 60

				case (.hours, .days):
					return value / 24

				case (.hours, .minutes):
					return value * 60

				case (.hours, .seconds):
					return value * 60 * 60

				case (.minutes, .days):
					return value / 60 / 24

				case (.minutes, .hours):
					return value / 60

				case (.minutes, .seconds):
					return value * 60

				case (.seconds, .days):
					return value / 60 / 60 / 24

				case (.seconds, .hours):
					return value / 60 / 60

				case (.seconds, .minutes):
					return value / 60

				default:
					return value
			}
		}
	}

	// MARK: - Volume
	enum Volume: String, Measurement {
		case liters = "Литры"
		case milliliters = "Миллилитры"
		case cups = "Стаканы"
		case pints = "Пинты"
		case gallons = "Галлоны"

		var symbol: String {
			switch self {
				case .liters: return "л"
				case .milliliters: return "мл"
				case .cups: return "ст"
				case .pints: return "пинта"
				case .gallons: return "гал"
			}
		}

		static func rest(of value: Volume) -> [Volume] {
			switch value {
				case .liters: return [.milliliters, .cups, .pints, .gallons]
				case .milliliters: return [.liters, .cups, .pints, .gallons]
				case .cups: return [.liters, .milliliters, .pints, .gallons]
				case .pints: return [.liters, .milliliters, .cups, .gallons]
				case .gallons: return [.liters, .milliliters, .cups, .pints]
			}
		}

		func convertValue(_ value: Double, of unit: Volume) -> Double {
			switch (self, unit) {
				case (.liters, .milliliters):
					return value * 1_000

				case (.liters, .cups):
					return value * 5

				case (.liters, .pints):
					return value * 2.1134

				case (.liters, .gallons):
					return value * 0.264172

				case (.milliliters, .liters):
					return value / 1_000

				case (.milliliters, .cups):
					return value / 1_000 * 5

				case (.milliliters, .pints):
					return value * 0.002113

				case (.milliliters, .gallons):
					return value * 0.000264

				case (.cups, .liters):
					return value * 0.2

				case (.cups, .milliliters):
					return value * 200

				case (.cups, .pints):
					return value * 0.422675

				case (.cups, .gallons):
					return value * 0.052834

				case (.pints, .milliliters):
					return value * 473.18

				case (.pints, .liters):
					return value * 473.18 / 1_000

				case (.pints, .cups):
					return value * 2.37

				case (.pints, .gallons):
					return value * 0.125

				case (.gallons, .liters):
					return value * 3.79

				case (.gallons, .milliliters):
					return value * 3_785.41

				case (.gallons, .cups):
					return value * 18.93

				case (.gallons, .pints):
					return value * 8

				default:
					return value
			}
		}
	}
}
