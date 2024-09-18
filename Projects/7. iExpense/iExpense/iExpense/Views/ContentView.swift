//
//  ContentView.swift
//  iExpense
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import SwiftUI

struct ContentView: View {
	// MARK: State
	@State private var expenses = Expenses()
	@State private var showingAddExpense = false

	// MARK: - Props
	private var personalExpenses: [Expenses.Item] {
		expenses.items.filter { $0.type == .personal }
	}
	private var businessExpenses: [Expenses.Item] {
		expenses.items.filter { $0.type == .business }
	}

	private func amountWeight(for item: Expenses.Item) -> Font.Weight {
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
		NavigationStack {
			List {
				if personalExpenses.isEmpty == false {
					Section("Персональные траты") {
						ForEach(personalExpenses, content: expenseView)
							.onDelete(perform: removePersonalItems)
					}
				}

				if businessExpenses.isEmpty == false {
					Section("Бизнес траты") {
						ForEach(businessExpenses, content: expenseView)
							.onDelete(perform: removeBusinessItems)
					}
				}
			}
			.navigationTitle("iExpense")
			.toolbar {
				Button("Добавить Расход", systemImage: "plus") {
					showingAddExpense.toggle()
				}
			}
			.sheet(isPresented: $showingAddExpense) {
				AddView(expenses: expenses)
					.interactiveDismissDisabled()
			}
		}
    }

	// MARK: - Views
	private func expenseView(for item: Expenses.Item) -> some View {
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

	// MARK: - Actions
	private func removePersonalItems(at offsets: IndexSet) {
		var temp = personalExpenses
		temp.remove(atOffsets: offsets)

		removeItems(from: temp)
	}

	private func removeBusinessItems(at offsets: IndexSet) {
		var temp = businessExpenses
		temp.remove(atOffsets: offsets)

		removeItems(from: temp)
	}

	private func removeItems(from items: [Expenses.Item]) {
		guard let type = items.first?.type else { return }

		for (index, item) in expenses.items.enumerated() where item.type == type {
			if items.contains(where: { $0.id == item.id }) == false {
				expenses.items.remove(at: index)
			}
		}
	}
}

#Preview {
    ContentView()
}
