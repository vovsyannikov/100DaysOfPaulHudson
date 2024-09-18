//
//  ExpensesListView.swift
//  iExpenseSwiftData
//
//  Created by Виталий Овсянников on 12.07.2024.
//

import SwiftData
import SwiftUI

struct ExpensesListView: View {
	@Environment(\.modelContext) private var modelContext

	@Query var expenses: [ExpenseItem]

	// MARK: - Props
	private var sectionedQuery: [ExpenseItem.ExpenseType: [ExpenseItem]] {
		let personalItems = expenses.filter { $0.type == .personal }
		let businessItems = expenses.filter { $0.type == .business }

		var results = [ExpenseItem.ExpenseType: [ExpenseItem]]()

		if personalItems.isEmpty == false {
			results[.personal] = personalItems
		}

		if businessItems.isEmpty == false {
			results[.business] = businessItems
		}

		return results
	}

	// MARK: - Initializer
	init(filter: ExpenseItem.ExpenseType, sortDescriptors: [SortDescriptor<ExpenseItem>]) {
		_expenses = Query(filter: ExpenseItem.predicate(for: filter), sort: sortDescriptors)
	}

	// MARK: - Body
    var body: some View {
		List {
			section(for: .personal)
			section(for: .business)
		}
    }

	// MARK: - Subviews
	@ViewBuilder
	private func section(for type: ExpenseItem.ExpenseType) -> some View {
		if let items = sectionedQuery[type] {
			Section(ExpenseItem.ExpenseType.business.sectionName) {
				ForEach(items, content: ExpenseView.init)
					.onDelete { indexSet in
						delete(at: indexSet, in: items)
					}
			}
		}
	}

	// MARK: - Actions
	private func delete(at offsets: IndexSet, in items: [ExpenseItem]) {
		for index in offsets {
			let item = items[index]

			modelContext.delete(item)
		}
	}
}

// MARK: - Previews
#Preview {
	ExpensesListView(filter: .all, sortDescriptors: [SortDescriptor(\.name)])
		.modelContainer(try! ExpenseItem.createPreviewContainer())
}
