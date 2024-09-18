//
//  EditView.swift
//  iExpense
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import SwiftUI

struct EditView: View {
	// MARK: Environment
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext

	// MARK: - State
	@Bindable var item: ExpenseItem

	// MARK: - Body
    var body: some View {
		NavigationStack {
			Form {
				TextField("Название", text: $item.name)

				Picker("Тип", selection: $item.type) {
					Text(ExpenseItem.ExpenseType.personal.rawValue)
						.tag(ExpenseItem.ExpenseType.personal)

					Text(ExpenseItem.ExpenseType.business.rawValue)
						.tag(ExpenseItem.ExpenseType.business)
				}

				CurrencyField("Сумма", value: $item.amount)
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
		modelContext.insert(item)

		dismiss()
	}
}

//#Preview {
//	Text("Hello")
//		.sheet(isPresented: .constant(true)) {
//			EditView()
//				.modelContainer(try! ExpenseItem.createPreviewContainer())
//		}
//}
