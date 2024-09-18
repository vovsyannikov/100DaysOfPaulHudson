//
//  ComplicatedSolution.swift
//  UnitConverter
//
//  Created by Виталий Овсянников on 03.07.2024.
//

import SwiftUI

// MARK: - ComplicatedSolution
struct ComplicatedSolution: View {
	@State private var selectedConverter = Converter.temperature
	@State private var selectedTemperature = Converter.Temperature.first
	@State private var selectedDistance = Converter.Distance.first
	@State private var selectedTime = Converter.Time.first
	@State private var selectedVolume = Converter.Volume.first

	@FocusState private var inputSelected: Bool

	@State private var inputValue = 0.0

	var body: some View {
		NavigationStack {
			Form {
				Section {
					converterPicker
				}

				Section {
					unitPicker
						.pickerStyle(.segmented)
					inputView
						.keyboardType(.decimalPad)
						.focused($inputSelected)
				}

				Section("Результаты") {
					outputView
				}
			}
			.navigationTitle("Сложный конвертер")
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

	// MARK: - Unit Pickers
	@ViewBuilder
	private var unitPicker: some View {
		switch selectedConverter {
			case .temperature: temperaturePicker
			case .distance: distancePicker
			case .time: timePicker
			case .volume: volumePicker
		}
	}

	private var temperaturePicker: some View {
		Picker(selectedConverter.rawValue, selection: $selectedTemperature) {
			ForEach(Converter.Temperature.allCases) {
				Text($0.symbol)
					.tag($0)
			}
		}
	}
	private var distancePicker: some View {
		Picker(selectedConverter.rawValue, selection: $selectedDistance) {
			ForEach(Converter.Distance.allCases) {
				Text($0.symbol)
					.tag($0)
			}
		}
	}
	private var timePicker: some View {
		Picker(selectedConverter.rawValue, selection: $selectedTime) {
			ForEach(Converter.Time.allCases) {
				Text($0.symbol)
					.tag($0)
			}
		}
	}
	private var volumePicker: some View {
		Picker(selectedConverter.rawValue, selection: $selectedVolume) {
			ForEach(Converter.Volume.allCases) {
				Text($0.symbol)
					.tag($0)
			}
		}
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
			Text(selectedTemperature.symbol)
				.foregroundStyle(.secondary)
			TextField("Значение", value: $inputValue, format: .number)
		}
	}

	private var distanceInput: some View {
		HStack {
			Text(selectedDistance.symbol)
				.foregroundStyle(.secondary)
			TextField("Значение", value: $inputValue, format: .number)
		}
	}

	private var timeInput: some View {
		HStack {
			Text(selectedTime.symbol)
				.foregroundStyle(.secondary)
			TextField("Значение", value: $inputValue, format: .number)
		}
	}

	private var volumeInput: some View {
		HStack {
			Text(selectedVolume.symbol)
				.foregroundStyle(.secondary)
			TextField("Значение", value: $inputValue, format: .number)
		}
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
		ForEach(Converter.Temperature.rest(of: selectedTemperature)) { value in
			VStack(alignment: .leading) {
				HStack {
					Text(value.symbol)
						.foregroundStyle(.secondary)
					Text(selectedTemperature.convertValue(inputValue, of: value), format: .number)
				}

				Text(selectedTemperature.conversionRate(for: value))
					.font(.caption)
					.foregroundStyle(.secondary)
			}
		}
	}

	private var distanceOutput: some View {
		ForEach(Converter.Distance.rest(of: selectedDistance)) { value in
			HStack {
				Text(value.symbol)
					.foregroundStyle(.secondary)
				Text(selectedDistance.convertValue(inputValue, of: value), format: .number)
			}
		}
	}

	private var timeOutput: some View {
		ForEach(Converter.Time.rest(of: selectedTime)) { value in
			HStack {
				Text(value.symbol)
					.foregroundStyle(.secondary)
				Text(selectedTime.convertValue(inputValue, of: value), format: .number)
			}
		}
	}

	private var volumeOutput: some View {
		ForEach(Converter.Volume.rest(of: selectedVolume)) { value in
			HStack {
				Text(value.symbol)
					.foregroundStyle(.secondary)
				Text(selectedVolume.convertValue(inputValue, of: value), format: .number)
			}
		}
	}
}

#Preview {
	ComplicatedSolution()
}
