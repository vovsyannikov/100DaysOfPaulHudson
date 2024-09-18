//
//  SimpleSolution.swift
//  UnitConverter
//
//  Created by Виталий Овсянников on 03.07.2024.
//

import SwiftUI

// MARK: - Simple Solution
struct SimpleSolution: View {
	@State private var selectedConverter = Converter.temperature

	@State private var inputTemperature = Converter.Temperature.first
	@State private var inputDistance = Converter.Distance.first
	@State private var inputTime = Converter.Time.first
	@State private var inputVolume = Converter.Volume.first

	@FocusState private var inputSelected: Bool

	@State private var inputValue = 0.0

	@State private var outputTemperature = Converter.Temperature.allCases[1]
	@State private var outputDistance = Converter.Distance.allCases[1]
	@State private var outputTime = Converter.Time.allCases[1]
	@State private var outputVolume = Converter.Volume.allCases[1]

	var conversionRate: String {
		switch selectedConverter {
			case .temperature:
				inputTemperature.conversionRate(for: outputTemperature)

			case .distance:
				inputDistance.conversionRate(for: outputDistance)

			case .time:
				inputTime.conversionRate(for: outputTime)

			case .volume:
				inputVolume.conversionRate(for: outputVolume)
		}
	}

	var body: some View {
		NavigationStack {
			Form {
				Section {
					converterPicker
				}

				Section {
					inputPicker
						.pickerStyle(.segmented)
					inputView
						.keyboardType(.decimalPad)
						.focused($inputSelected)
				}

				Section("Результат: \(conversionRate)") {
					outputPicker
						.pickerStyle(.segmented)
					outputView
				}
			}
			.navigationTitle("Простой конвертер")
			.toolbar {
				ToolbarItem(placement: .keyboard) {
					Button("Готово") { inputSelected = false }
						.frame(maxWidth: .infinity, alignment: .trailing)
				}
			}
			.onChange(of: selectedConverter) {
				inputValue = 0
			}
		}
	}

	private var converterPicker: some View {
		Picker("Конвертер", selection: $selectedConverter) {
			ForEach(Converter.allCases) {
				Text($0.rawValue)
					.tag($0)
			}
		}
	}

	// MARK: - Input Pickers
	@ViewBuilder
	private var inputPicker: some View {
		switch selectedConverter {
			case .temperature: temperatureInputPicker
			case .distance: distanceInputPicker
			case .time: timeInputPicker
			case .volume: volumeInputPicker
		}
	}
	private var temperatureInputPicker: some View {
		temperaturePickerView(for: $inputTemperature)
	}
	private var distanceInputPicker: some View {
		distancePickerView(for: $inputDistance)
	}
	private var timeInputPicker: some View {
		timePickerView(for: $inputTime)
	}
	private var volumeInputPicker: some View {
		volumePickerView(for: $inputVolume)
	}

	// MARK: - Input Views
	@ViewBuilder
	private var inputView: some View {
		switch selectedConverter {
			case .temperature: temperatureInput
			case .distance: distanceInput
			case .time: timeInput
			case .volume: volumeInput
		}
	}

	private var temperatureInput: some View {
		HStack {
			Text(inputTemperature.symbol)
				.foregroundStyle(.secondary)
			TextField("Значение", value: $inputValue, format: .number)
		}
	}

	private var distanceInput: some View {
		HStack {
			Text(inputDistance.symbol)
				.foregroundStyle(.secondary)
			TextField("Значение", value: $inputValue, format: .number)
		}
	}

	private var timeInput: some View {
		HStack {
			Text(inputTime.symbol)
				.foregroundStyle(.secondary)
			TextField("Значение", value: $inputValue, format: .number)
		}
	}

	private var volumeInput: some View {
		HStack {
			Text(inputVolume.symbol)
				.foregroundStyle(.secondary)
			TextField("Значение", value: $inputValue, format: .number)
		}
	}

	// MARK: - Output Pickers
	@ViewBuilder
	private var outputPicker: some View {
		switch selectedConverter {
			case .temperature: temperatureOutputPicker
			case .distance: distanceOutputPicker
			case .time: timeOutputPicker
			case .volume: volumeOutputPicker
		}
	}
	private var temperatureOutputPicker: some View {
		temperaturePickerView(for: $outputTemperature)
	}
	private var distanceOutputPicker: some View {
		distancePickerView(for: $outputDistance)
	}
	private var timeOutputPicker: some View {
		timePickerView(for: $outputTime)
	}
	private var volumeOutputPicker: some View {
		volumePickerView(for: $outputVolume)
	}

	// MARK: - Output Views
	@ViewBuilder
	private var outputView: some View {
		switch selectedConverter {
			case .temperature: temperatureOutput
			case .distance: distanceOutput
			case .time: timeOutput
			case .volume: volumeOutput
		}
	}

	private var temperatureOutput: some View {
		let value = outputTemperature

		return HStack {
			Text(value.symbol)
				.foregroundStyle(.secondary)
			Text(inputTemperature.convertValue(inputValue, of: value), format: .number)
		}
	}

	private var distanceOutput: some View {
		let value = outputDistance

		return HStack {
			Text(value.symbol)
				.foregroundStyle(.secondary)
			Text(inputDistance.convertValue(inputValue, of: value), format: .number)
		}
	}

	private var timeOutput: some View {
		let value = outputTime

		return HStack {
			Text(value.symbol)
				.foregroundStyle(.secondary)
			Text(inputTime.convertValue(inputValue, of: value), format: .number)
		}
	}

	private var volumeOutput: some View {
		let value = outputVolume

		return HStack {
			Text(value.symbol)
				.foregroundStyle(.secondary)
			Text(inputVolume.convertValue(inputValue, of: value), format: .number)
		}
	}

	private func temperaturePickerView<V: Hashable>(for value: Binding<V>) -> some View {
		Picker(selectedConverter.rawValue, selection: value) {
			ForEach(Converter.Temperature.allCases) {
				Text($0.symbol)
					.tag($0)
			}
		}
	}

	private func distancePickerView<V: Hashable>(for value: Binding<V>) -> some View {
		Picker(selectedConverter.rawValue, selection: value) {
			ForEach(Converter.Distance.allCases) {
				Text($0.symbol)
					.tag($0)
			}
		}
	}

	private func timePickerView<V: Hashable>(for value: Binding<V>) -> some View {
		Picker(selectedConverter.rawValue, selection: value) {
			ForEach(Converter.Time.allCases) {
				Text($0.symbol)
					.tag($0)
			}
		}
	}

	private func volumePickerView<V: Hashable>(for value: Binding<V>) -> some View {
		Picker(selectedConverter.rawValue, selection: value) {
			ForEach(Converter.Volume.allCases) {
				Text($0.symbol)
					.tag($0)
			}
		}
	}
}

#Preview {
	SimpleSolution()
}
