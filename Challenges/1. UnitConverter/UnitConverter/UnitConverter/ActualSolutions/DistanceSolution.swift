//
//  DistanceSolution.swift
//  UnitConverter
//
//  Created by Виталий Овсянников on 03.07.2024.
//

import SwiftUI

struct DistanceSolution: View {
	@State private var inputUnit = Converter.Distance.allCases[0].rawValue
	@State private var inputValue = 0.0

	@State private var outputUnit = Converter.Distance.allCases[1].rawValue

	var conversion: Double {
		let inputType = Converter.Distance(rawValue: inputUnit)!
		let outputType = Converter.Distance(rawValue: outputUnit)!

		return inputType.convertValue(inputValue, of: outputType)
	}

	var body: some View {
		Form {
			Section {
				Picker("Исходное значение", selection: $inputUnit) {
					ForEach(Converter.Distance.allCases) {
						Text($0.symbol)
					}
				}
				.pickerStyle(.segmented)

				TextField("Значение", value: $inputValue, format: .number)
			}

			Section("Результат") {
				Picker("Исходное значение", selection: $outputUnit) {
					ForEach(Converter.Distance.allCases) {
						Text($0.symbol)
					}
				}
				.pickerStyle(.segmented)

				Text(conversion, format: .number)
			}
		}
		.navigationTitle("Конвертер расстояний")
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
	NavigationStack {
		DistanceSolution()
	}
}
