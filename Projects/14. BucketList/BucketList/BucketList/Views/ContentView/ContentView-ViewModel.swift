//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Виталий Овсянников on 15.07.2024.
//

import Foundation
import LocalAuthentication
import MapKit

extension ContentView {
	@Observable
	class ViewModel {
		// MARK: - Props
		private let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
		private(set) var locations: [Location]

		var selectedLocation: Location?
		var isUnlocked = false
		var showErrorMessage = false
		var error: AuthError?

		// MARK: - Initializer
		init() {
			do {
				let data = try Data(contentsOf: savePath)
				locations = try JSONDecoder().decode([Location].self, from: data)
			} catch {
				locations = []
			}
		}

		// MARK: - Actions
		func authenticate() {
			let context = LAContext()
			var error: NSError?

			defer {
				if let error {
					self.error = .noBiometrics(description: error.localizedDescription)
				}

				if self.error != nil {
					showErrorMessage = true
				}
			}
			
			guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else { return }
			let reason  = "Разблокируйте устройство для получения доступа к местам"

			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
				if success {
					self.isUnlocked = true
				} else {
					self.error = .didNotEvaluate(description: authError?.localizedDescription)
				}
			}
		}

		func addLocation(at coordinates: CLLocationCoordinate2D) {
			let newLocation = Location("Новое место", coordinates: coordinates)

			locations.append(newLocation)
			selectedLocation = newLocation

			save()
		}

		func update(with updatedLocation: Location) {
			guard let selectedLocation, let index = locations.firstIndex(of: selectedLocation)
			else { return }

			locations[index] = updatedLocation

			save()
		}

		private func save() {
			do {
				let data = try JSONEncoder().encode(locations)

				try FileManager.default.write(data, to: savePath)
			} catch {
				print("Error saving locations: \(error.localizedDescription)")
			}
		}
	}
}

extension ContentView {
	enum AuthError: LocalizedError {
		case noBiometrics(description: String?)
		case didNotEvaluate(description: String?)

		var errorDescription: String? {
			switch self {
				case .noBiometrics(description: let localizedDescription):
					localizedDescription

				case .didNotEvaluate(description: let localizedDescription):
					localizedDescription
			}
		}
	}
}
