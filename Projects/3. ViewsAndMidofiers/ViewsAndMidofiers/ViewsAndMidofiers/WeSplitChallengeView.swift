//
//  WeSplitChallengeView.swift
//  ViewsAndModifiers
//
//  Created by Виталий Овсянников on 06.07.2024.
//

import Foundation

import SwiftUI

struct WeSplitChallengeView: View {
	@State private var checkAmount = 0.0
	@State private var numberOfPeople = 2
	@State private var tipPercentage = 20

	@FocusState private var amountFocused: Bool

	private let currencyCode = Locale.current.currency?.identifier ?? "RUB"
	private var currencySymbol: String {
		if Locale.current.currency?.identifier == "RUB" {
			return "₽"
		} else {
			return Locale.current.currencySymbol ?? "$"
		}
	}
	private let tipPercentages = [10, 15, 20, 25, 0]

	private var totalAmount: Double {
		let tipSelection = Double(tipPercentage)

		let tipValue = checkAmount / 100 * tipSelection
		let grandTotal = checkAmount + tipValue

		return grandTotal
	}

	private var totalPerPerson: Double {
		let peopleCount = Double(numberOfPeople) + 2
		let amountPerPerson = totalAmount / peopleCount

		return amountPerPerson
	}

	var body: some View {
			Form {
				Section {
					HStack {
						Text(currencySymbol)
							.foregroundStyle(.secondary)
						TextField("Сумма", value: $checkAmount, format: .number)
							.keyboardType(.decimalPad)
							.focused($amountFocused)
					}

					Picker("Количество человек", selection: $numberOfPeople) {
						ForEach(2..<100) { Text("\($0)") }
					}
				}

				Section("Сколько оставить на чай?") {
					Picker("Чаевые", selection: $tipPercentage) {
						ForEach(0...100, id: \.self) {
							Text($0, format: .percent)
						}
					}
					.pickerStyle(.navigationLink)
				}

				Section("Общая сумма") {
					amountView(for: totalAmount)
						.foregroundStyle(tipPercentage == 0 ? .red : .primary)
				}

				Section("Сумма с человека") {
					amountView(for: totalPerPerson)
				}
			}
			.navigationTitle("Делись")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .keyboard) {
					Button("Готово") {
						amountFocused = false
					}
					.frame(maxWidth: .infinity, alignment: .trailing)
				}
			}
	}

	private func amountView(for amount: Double) -> some View {
		HStack {
			Text(currencySymbol)
				.foregroundStyle(.secondary)
			Text(amount, format: .number)
		}
	}
}

#Preview {
	NavigationStack {
		WeSplitChallengeView()
	}
}
