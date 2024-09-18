//
//  Location.swift
//  BucketList
//
//  Created by Виталий Овсянников on 15.07.2024.
//

import Foundation
import MapKit

struct Location: Codable, Identifiable {
	var id = UUID()

	var name: String
	var description: String

	var latitude: Double
	var longitude: Double

	var coordinates: CLLocationCoordinate2D {
		get { .init(latitude: latitude, longitude: longitude) }
		set {
			latitude = newValue.latitude
			longitude = newValue.longitude
		}
	}
}

// MARK: - Equatable
extension Location: Equatable {
	static func ==(lhs: Location, rhs: Location) -> Bool {
		lhs.id == rhs.id
	}
}

// MARK: - Convenience Initializer
extension Location {
	init(_ name: String, description: String = "", coordinates: CLLocationCoordinate2D) {
		self.name = name
		self.description = description
		self.latitude = coordinates.latitude
		self.longitude = coordinates.longitude
	}
}

#if DEBUG
// MARK: - Example
extension Location {
	static let example = Location(name: "Букингемcкий дворец",
								  description: "Подсвечивается более чем 40 000 лампочек",
								  latitude: 51.501,
								  longitude: -0.141)
}
#endif
