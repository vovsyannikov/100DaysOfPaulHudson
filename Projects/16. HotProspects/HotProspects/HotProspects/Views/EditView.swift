//
//  EditView.swift
//  HotProspects
//
//  Created by Виталий Овсянников on 16.07.2024.
//

import SwiftUI

struct EditView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext

	@State private var showDeleteAlert = false

	@Bindable var prospect: Prospect

	// MARK: - Props
	private var contactedInfo: (title: String, image: String, color: Color) {
		prospect.isContacted
		? ("Убрать из контактов", "person.crop.circle.badge.xmark", .blue)
		: ("Добавить в контакты", "person.crop.circle.fill.badge.checkmark", .green)
	}

	// MARK: - Body
    var body: some View {
		List {
			TextField("Электронный адрес", text: $prospect.emailAddress)

			DatePicker("Дата встречи", selection: $prospect.dateAdded, displayedComponents: .date)

			Section {
				QRCodeView(from: prospect)
			}

			Section {
				Button("Напомнить о контакте", systemImage: "bell.fill") {
					UNUserNotificationCenter.current().addNotification(for: prospect)
				}
				.foregroundStyle(.orange)

				Button(contactedInfo.title, systemImage: contactedInfo.image) {
					prospect.isContacted.toggle()
				}
				.foregroundStyle(contactedInfo.color)
			}

			Section {
				Button("Удалить", systemImage: "trash", role: .destructive) {
					showDeleteAlert = true
				}
				.foregroundStyle(.red)
			}
		}
		.navigationTitle($prospect.name)
		.navigationBarTitleDisplayMode(.inline)
		.alert("Удалить \(prospect.name)", isPresented: $showDeleteAlert) {
			Button("Удалить", role: .destructive, action: delete)
		}
    }

	// MARK: - Actions
	private func delete() {
		modelContext.delete(prospect)
		dismiss()
	}
}

// MARK: - Preview
#Preview {
	NavigationStack {
		EditView(prospect: .example)
	}
	.modelContainer(Prospect.container)
}
