//
//  ExpenseView.swift
//  iExpenseSwiftData
//
//  Created by Виталий Овсянников on 12.07.2024.
//

import SwiftUI

struct ExpenseView: View {
	let item: ExpenseItem

	// MARK: - Props
	private func amountWeight(for item: ExpenseItem) -> Font.Weight {
		if item.amount < 100 {
			.ultraLight
		} else if item.amount < 5_000 {
			.regular
		} else {
			.heavy
		}
	}

	// MARK: - Body
    var body: some View {
		HStack {
			VStack(alignment: .leading) {
				Text(item.name)
				Text(item.type.rawValue)
					.font(.caption)
					.foregroundStyle(.secondary)
			}

			Spacer()

			HStack(spacing: 5) {
				Text(item.amount, format: .number.precision(.fractionLength(2)))
				Text(Locale.current.localizedCurrencySymbol)
			}
			.fontWeight(amountWeight(for: item))
		}
    }
}

#Preview(traits: .sizeThatFitsLayout) {
	ExpenseView(item: ExpenseItem(name: "Тестовая трата"))
}
