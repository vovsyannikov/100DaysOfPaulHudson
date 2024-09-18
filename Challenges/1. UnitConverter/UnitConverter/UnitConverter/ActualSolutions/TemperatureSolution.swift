//
//  TemperatureSolution.swift
//  UnitConverter
//
//  Created by Виталий Овсянников on 03.07.2024.
//

import SwiftUI

struct TemperatureSolution: View {
	@State private var inputUnit = Converter.Temperature.allCases[0].rawValue
	@State private var inputValue = 0.0

	@State private var outputUnit = Converter.Temperature.allCases[1].rawValue

	var conversion: Double {
		let inputType = Converter.Temperature(rawValue: inputUnit)!
		let outputType = Converter.Temperature(rawValue: outputUnit)!

		return inputType.convertValue(inputValue, of: outputType)
	}

	var body: some View {
		Form {
			Section {
				Picker("Исходное значение", selection: $inputUnit) {
					ForEach(Converter.Temperature.allCases) {
						Text($0.symbol)
					}
				}
				.pickerStyle(.segmented)

				TextField("Значение", value: $inputValue, format: .number)
			}

			Section("Результат") {
				Picker("Исходное значение", selection: $outputUnit) {
					ForEach(Converter.Temperature.allCases) {
						Text($0.symbol)
					}
				}
				.pickerStyle(.segmented)

				Text(conversion, format: .number)
			}
		}
		.navigationTitle("Конвертер температур")
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
	NavigationStack {
		TemperatureSolution()
	}
}
