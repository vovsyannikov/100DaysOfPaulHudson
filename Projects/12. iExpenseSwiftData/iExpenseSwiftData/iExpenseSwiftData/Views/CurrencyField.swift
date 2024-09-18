//
//  CurrencyField.swift
//  iExpense
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import SwiftUI

struct CurrencyField: View {
	@Binding var value: Double

	let placeholder: String

	private let currencySymbol = Locale.current.localizedCurrencySymbol

	init(_ placeholder: String, value: Binding<Double>) {
		self._value = value
		self.placeholder = placeholder
	}

	var body: some View {
		HStack {
			Text(currencySymbol)
				.foregroundStyle(.secondary)

			TextField(placeholder, value: $value, format: .number)
		}
	}
}

#Preview {
	CurrencyField("Placeholder", value: .constant(12.5))
}
