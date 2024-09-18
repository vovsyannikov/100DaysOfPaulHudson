//
//  TimeSolution.swift
//  UnitConverter
//
//  Created by Виталий Овсянников on 03.07.2024.
//

import SwiftUI

struct TimeSolution: View {
	@State private var inputUnit = Converter.Time.allCases[0].rawValue
	@State private var inputValue = 0.0

	@State private var outputUnit = Converter.Time.allCases[1].rawValue

	var conversion: Double {
		let inputType = Converter.Time(rawValue: inputUnit)!
		let outputType = Converter.Time(rawValue: outputUnit)!

		return inputType.convertValue(inputValue, of: outputType)
	}

	var body: some View {
		Form {
			Section {
				Picker("Исходное значение", selection: $inputUnit) {
					ForEach(Converter.Time.allCases) {
						Text($0.symbol)
					}
				}
				.pickerStyle(.segmented)

				TextField("Значение", value: $inputValue, format: .number)
			}

			Section("Результат") {
				Picker("Исходное значение", selection: $outputUnit) {
					ForEach(Converter.Time.allCases) {
						Text($0.symbol)
					}
				}
				.pickerStyle(.segmented)

				Text(conversion, format: .number)
			}
		}
		.navigationTitle("Конвертер времени")
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
	NavigationStack {
		TimeSolution()
	}
}
