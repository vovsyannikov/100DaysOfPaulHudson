//
//  AddView.swift
//  iExpense
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import SwiftUI

struct AddView: View {
	// MARK: Environment
	@Environment(\.dismiss) private var dismiss

	// MARK: - State
	@State private var name = ""
	@State private var type = Expenses.Item.ExpenseType.personal
	@State private var amount = 0.0

	// MARK: - Props
	let expenses: Expenses

	// MARK: - Body
    var body: some View {
		NavigationStack {
			Form {
				TextField("Название", text: $name)

				Picker("Тип", selection: $type) {
					ForEach(Expenses.Item.ExpenseType.allCases, id: \.rawValue) { expenseType in
						Text(expenseType.rawValue)
							.tag(expenseType)
					}
				}

				CurrencyField("Сумма", value: $amount)
					.keyboardType(.decimalPad)
			}
			.navigationTitle("Добавить расход")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				Button("Сохранить", action: saveExpense)
			}
		}
    }

	// MARK: - Actions
	private func saveExpense() {
		let item = Expenses.Item(name: name, type: type, amount: amount)

		expenses.items.append(item)

		dismiss()
	}
}

#Preview {
	Text("Hello")
		.sheet(isPresented: .constant(true)) {
			AddView(expenses: Expenses())
		}
}
