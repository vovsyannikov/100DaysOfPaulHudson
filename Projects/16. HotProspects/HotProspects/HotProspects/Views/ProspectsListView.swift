//
//  ProspectsListView.swift
//  HotProspects
//
//  Created by Виталий Овсянников on 16.07.2024.
//

import SwiftData
import SwiftUI

struct ProspectsListView: View {
	@Environment(\.modelContext) private var modelContext

	@Query private var prospects: [Prospect]

	@State private var selectedProspects = Set<Prospect>()

	// MARK: Props
	let filter: Prospect.FilterType

	// MARK: - Initializers
	init(filter: Prospect.FilterType, sortOrder: [SortDescriptor<Prospect>]) {
		self.filter = filter

		var predicate: Predicate<Prospect>?

		if filter != .all {
			let showContactOnly = filter == .contacted
			predicate = #Predicate { $0.isContacted == showContactOnly }
		}

		_prospects = Query(filter: predicate, sort: sortOrder)
	}

	// MARK: - Body
	var body: some View {
		if prospects.isEmpty {
			emptyView
		} else {
			prospectsListView
		}
	}

	// MARK: - Subviews
	private var emptyView: some View {
		ContentUnavailableView("Нет контактов", systemImage: "person.3.fill")
			.foregroundStyle(.primary, .blue)
	}

	private var prospectsListView: some View {
		List(prospects, selection: $selectedProspects) { prospect in
			NavigationLink {
				EditView(prospect: prospect)
			} label: {
				prospectView(for: prospect)
			}
			.onDisappear {
				selectedProspects.remove(prospect)
			}
			.tag(prospect)
			.swipeActions {
				Button("Удалить", systemImage: "trash", role: .destructive) {
					modelContext.delete(prospect)
				}

				if prospect.isContacted {
					Button("Убрать из контактов", systemImage: "person.crop.circle.badge.xmark") {
						prospect.isContacted.toggle()
					}
					.tint(.blue)
				} else {
					Button("Добавить в контакты", systemImage: "person.crop.circle.fill.badge.checkmark") {
						prospect.isContacted.toggle()
					}
					.tint(.green)
				}
			}
			.swipeActions(edge: .leading) {
				Button("Напомнить", systemImage: "bell") {
					addNotification(for: prospect)
				}
				.tint(.orange)
			}
			.toolbar {
				if selectedProspects.isEmpty == false {
					ToolbarItem(placement: .bottomBar) {
						Button("Удалить выбранные контакты", action: delete)
					}
				}
			}
		}
	}

	private func prospectView(for prospect: Prospect) -> some View {
		HStack {
			VStack(alignment: .leading, spacing: 10) {
				VStack(alignment: .leading) {
					Text(prospect.name)
						.font(.headline)

					Text(prospect.emailAddress)
						.foregroundStyle(.secondary)
				}

				Text("Встретились: \(prospect.dateAdded.formatted(date: .abbreviated, time: .omitted))")
					.font(.caption)
					.foregroundStyle(.secondary)
			}

			if filter == .all, prospect.isContacted {
				Spacer()

				Image(systemName: "checkmark.circle.fill")
					.foregroundStyle(.white, .green)
			}
		}
	}

	// MARK: - Actions
	private func delete() {
		selectedProspects.forEach(modelContext.delete)
		selectedProspects = []
	}

	private func addNotification(for prospect: Prospect) {
		UNUserNotificationCenter.current().addNotification(for: prospect)
	}
}

// MARK: - Previews
#Preview {
	ProspectsListView(filter: .all, sortOrder: [.init(\.name)])
}
