//
//  ContentView.swift
//  iExpense
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import SwiftUI

struct ContentView: View {
	// MARK: State
	@Environment(\.modelContext) private var modelContext

	@State private var showingAddExpense = false
	@State private var sortOrder = [SortDescriptor(\ExpenseItem.name)]
	@State private var filter = ExpenseItem.ExpenseType.all
	@State private var selectedItem: ExpenseItem?

	// MARK: - Body
	var body: some View {
		NavigationStack {
			ExpensesListView(filter: filter, sortDescriptors: sortOrder)
				.navigationTitle("iExpense")
				.toolbar { menu }
				.sheet(item: $selectedItem) { item in
					EditView(item: item)
				}
		}
    }

	// MARK: - Subviews
	private var menu: some View {
		Menu("Сортировка", systemImage: "ellipsis.circle") {
			Section {
				Button("Новая трата", systemImage: "plus") {
					selectedItem = ExpenseItem(name: "Hello")
				}
			}

			sortPicker
			filterPicker
		}
	}

	private var sortPicker: some View {
		Picker("Сортировка", selection: $sortOrder.animation()) {
			Text("Имя")
				.tag([SortDescriptor(\ExpenseItem.name)])

			Text("Стоимость")
				.tag([
					SortDescriptor(\ExpenseItem.amount),
					SortDescriptor(\ExpenseItem.name)
				])
		}
		.pickerStyle(.menu)
	}

	private var filterPicker: some View {
		Picker("Фильтр", selection: $filter.animation()) {
			ForEach(ExpenseItem.ExpenseType.allCases) { type in
				Text(type.rawValue)
					.tag(type)
			}
		}
		.pickerStyle(.menu)
	}
}

// MARK: - Preview
#Preview {
    ContentView()
		.modelContainer(try! ExpenseItem.createPreviewContainer())
}
