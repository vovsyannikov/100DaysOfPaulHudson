//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Виталий Овсянников on 20.07.2024.
//

import OSLog
import SwiftUI

@Observable
final class Favorites {
	private let key = "Favorites"

	private var resorts: Set<String>

	init() {
		if let encodedString = UserDefaults.standard.string(forKey: key) {
			resorts = Set(encodedString.components(separatedBy: ","))
			return
		}

		resorts = []
	}

	func add(_ resort: Resort) {
		Logger.data.info("Adding '\(resort.id)' (\(resort.name)) to favorites")
		resorts.insert(resort.id)
		save()
	}

	func contains(_ resort: Resort) -> Bool {
		resorts.contains(resort.id)
	}

	func remove(_ resort: Resort) {
		Logger.data.info("Removing '\(resort.id)' (\(resort.name)) to favorites")
		resorts.remove(resort.id)
		save()
	}

	func save() {
		let resortsString = resorts.joined(separator: ",")

		Logger.data.info("Saving favorite resorts")
		UserDefaults.standard.setValue(resortsString, forKey: key)
	}
}
