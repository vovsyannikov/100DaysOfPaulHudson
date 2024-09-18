//
//  Resort.swift
//  SnowSeeker
//
//  Created by Виталий Овсянников on 18.07.2024.
//

import Foundation

struct Resort: Codable, Hashable, Identifiable {
	var id: String
	var name: String
	var country: String
	var description: String
	var imageCredit: String
	
	var price: Price
	var size: Size

	var snowDepth: Int
	var elevation: Int
	var runs: Int

	var facilities: [Facility]

	var snowDepthDescription: String {
		"\(snowDepth.formatted()) cm"
	}
	var elevationDescription: String {
		"\(elevation.formatted()) m"
	}
}

extension Resort {
	enum Price: Int, Codable {
		case cheap = 1
		case medium = 2
		case expensive = 3

		var description: String {
			String(repeating: "$", count: rawValue)
		}
	}

	enum Size: Int, Codable {
		case small = 1
		case average = 2
		case large = 3

		var description: String {
			switch self {
				case .small: "Small"
				case .average: "Average"
				case .large: "Large"
			}
		}
	}

	enum Sort: String, CaseIterable, Identifiable {
		var id: Self { self }

		case `default` = "Default"
		case alphabetical = "Alphabetical"
		case byCountry = "By Country"
	}
}

#if DEBUG
extension Resort {
	static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
	static let example = allResorts[0]
}
#endif
