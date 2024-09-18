//
//  EditView.swift
//  BucketList
//
//  Created by Виталий Овсянников on 15.07.2024.
//

import SwiftUI

struct EditView: View {
	// MARK: State
	@Environment(\.dismiss) var dismiss

	@State private var viewModel: ViewModel

	// MARK: - Props
	var onSave: (Location) -> Void

	// MARK: - Initializer
	init(for location: Location, onSave: @escaping (Location) -> Void) {
		self._viewModel = State(initialValue: ViewModel(with: location))

		self.onSave = onSave
	}

	// MARK: - Body
    var body: some View {
		NavigationStack {
			Form {
				Section {
					TextField("Название места", text: $viewModel.name)
					TextField("Описание", text: $viewModel.description, axis: .vertical)
				}

				Section("Места поблизости") {
					switch viewModel.loadingState {
						case .loading:
							ProgressView("Загружаем места поблизости")
								.frame(maxWidth: .infinity)

						case .complete:
							ForEach(viewModel.pages, id: \.pageid) { page in
								Text(page.title)
									.font(.headline)

								+ Text(": ") +

								Text(page.description)
									.italic()
							}

						case .failed(let reason):
							Text("Что-то пошло не так: \(reason)")
					}
				}
			}
			.navigationTitle("Описание места")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				Button("Сохранить") {
					onSave(viewModel.location)
					dismiss()
				}
			}
			.task {
				await viewModel.fetchNearbyPlaces()
			}
		}
    }
}

// MARK: - Loading State
extension EditView {
	enum LoadingState {
		case loading
		case complete
		case failed(reason: String)
	}
}

// MARK: - Previews
#Preview {
	EditView(for: .example) { _ in }
}
