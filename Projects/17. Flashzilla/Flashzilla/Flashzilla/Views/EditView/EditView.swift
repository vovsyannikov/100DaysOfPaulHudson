//
//  EditView.swift
//  Flashzilla
//
//  Created by Виталий Овсянников on 16.07.2024.
//

import SwiftUI

struct EditView: View {
	// MARK: State
	@Environment(\.dismiss) private var dismiss

	@State private var viewModel = ViewModel()

	// MARK: - Body
    var body: some View {
		NavigationStack {
			List {
				Section("Добавить новую карточку") {
					TextField("Вопрос", text: $viewModel.newPrompt)
					TextField("Ответ", text: $viewModel.newAnswer)

					Button("Добавить", action: viewModel.addCard)
				}

				Section {
					ForEach(0..<viewModel.cardCount, id: \.self) { index in
						VStack(alignment: .leading) {
							Text(viewModel.cards[index].prompt)
								.font(.headline)

							Text(viewModel.cards[index].answer)
								.foregroundStyle(.secondary)
						}
					}
					.onDelete(perform: viewModel.removeCards)
				}
			}
			.navigationTitle("Изменить карточки")
			.toolbar {
				Button("Готово", action: done)
			}
		}
    }

	// MARK: - Actions
	private func done() {
		dismiss()
	}

}

// MARK: - Previews
#Preview {
    EditView()
}
