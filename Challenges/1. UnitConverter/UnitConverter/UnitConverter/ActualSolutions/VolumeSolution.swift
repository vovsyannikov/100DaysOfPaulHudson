//
//  VolumeSolution.swift
//  UnitConverter
//
//  Created by Виталий Овсянников on 03.07.2024.
//

import SwiftUI

struct VolumeSolution: View {
	@State private var inputUnit = Converter.Volume.allCases[0].rawValue
	@State private var inputValue = 0.0

	@State private var outputUnit = Converter.Volume.allCases[1].rawValue

	var conversion: Double {
		let inputType = Converter.Volume(rawValue: inputUnit)!
		let outputType = Converter.Volume(rawValue: outputUnit)!

		return inputType.convertValue(inputValue, of: outputType)
	}

	var body: some View {
		Form {
			Section {
				Picker("Исходное значение", selection: $inputUnit) {
					ForEach(Converter.Volume.allCases) {
						Text($0.symbol)
					}
				}
				.pickerStyle(.segmented)

				TextField("Значение", value: $inputValue, format: .number)
			}

			Section("Результат") {
				Picker("Исходное значение", selection: $outputUnit) {
					ForEach(Converter.Volume.allCases) {
						Text($0.symbol)
					}
				}
				.pickerStyle(.segmented)

				Text(conversion, format: .number)
			}
		}
		.navigationTitle("Конвертер объёма")
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
	NavigationStack {
		VolumeSolution()
	}
}
