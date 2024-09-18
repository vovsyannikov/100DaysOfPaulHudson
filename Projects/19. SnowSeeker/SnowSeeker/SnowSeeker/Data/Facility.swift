//
//  Facility.swift
//  SnowSeeker
//
//  Created by Виталий Овсянников on 18.07.2024.
//

import SwiftUI

extension Resort {
	enum Facility: String, Codable, Hashable ,Identifiable {
		var id: Self { self }

		case accommodations = "Accommodation"
		case beginners = "Beginners"
		case crossCounty = "Cross-country"
		case eco = "Eco-friendly"
		case family = "Family"

		var description: String {
			switch self {
				case .accommodations:
					"This resort has popular on-site accommodations."
				case .beginners:
					"This resort has lots of ski schools."
				case .crossCounty:
					"This resort has many cross-country ski routes."
				case .eco:
					"This resort has won an award for environment friendliness."
				case .family:
					"This resort is popular with families"
			}
		}

		var icon: some View {
			let icon = switch self {
				case .accommodations:
					"house"
				case .beginners:
					"1.circle"
				case .crossCounty:
					"map"
				case .eco:
					"leaf.arrow.circlepath"
				case .family:
					"person.3"
			}

			return Image(systemName: icon)
				.accessibilityLabel(rawValue)
				.foregroundStyle(.secondary)
		}
	}
}

