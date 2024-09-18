//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Виталий Овсянников on 16.07.2024.
//

import Foundation

extension EditView {
	@Observable
	final class ViewModel {
		var location: Location

		var name: String {
			get { location.name }
			set { location.name = newValue }
		}

		var description: String {
			get { location.description }
			set { location.description = newValue }
		}

		var loadingState = LoadingState.loading
		var pages = [WikiResult.Query.Page]()

		// MARK: - Initializer
		init(with location: Location) {
			self.location = location
			self.location.id = UUID()
		}

		// MARK: - Actions
		func fetchNearbyPlaces() async {
			loadingState = .loading

			guard let url = WikiResult.url(for: location) else {
				loadingState = .failed(reason: "Bad URL")
				return
			}

			do {
				let (data, _) = try await URLSession.shared.data(from: url)
				let result = try JSONDecoder().decode(WikiResult.self, from: data)

				pages = result.query.pages.values.sorted()
				loadingState = .complete
			} catch {
				loadingState = .failed(reason: error.localizedDescription)
			}
		}
	}
}
