//
//  Prospect.swift
//  HotProspects
//
//  Created by Виталий Овсянников on 16.07.2024.
//

import Foundation
import SwiftData

@Model
final class Prospect: Hashable {
	var name: String
	var emailAddress: String
	var isContacted: Bool

	var dateAdded = Date()

	var codeString: String {
		Self.generateCode(name: name, emailAddress: emailAddress)
	}

	init(name: String, emailAddress: String, isContacted: Bool = false) {
		self.name = name
		self.emailAddress = emailAddress
		self.isContacted = isContacted
	}

	static func generateCode(name: String, emailAddress: String) -> String {
		"\(name)\n\(emailAddress)"
	}
}

// MARK: - FilterType
extension Prospect {
	enum FilterType {
		case all
		case contacted
		case noContact
		
		var title: String {
			switch self {
				case .all: "Все"
				case .contacted: "В контактах"
				case .noContact: "Незнакомые"
			}
		}
	}
}

// MARK: - SortType
extension Prospect {
	enum SortType: Identifiable, CaseIterable {
		var id: Self { self }

		case byName
		case byDateMet

		var descriptors: [SortDescriptor<Prospect>] {
			switch self {
				case .byName: [SortDescriptor(\Prospect.name)]
				case .byDateMet: [SortDescriptor(\Prospect.dateAdded, order: .reverse),
								  SortDescriptor(\Prospect.name)]
			}
		}

		var label: (title: String, image: String) {
			switch self {
				case .byName: ("Имя", "person")
				case .byDateMet: ("Дата встречи", "calendar")
			}

		}
	}
}

#if DEBUG
// MARK: - Example Data
extension Prospect {
	static let example = Prospect(name: "Павел Хадсонов", emailAddress: "paul@hackingwithswift.com", isContacted: false)

	@MainActor
	static let container: ModelContainer = {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try! ModelContainer(for: Prospect.self, configurations: config)

		container.mainContext.insert(Prospect.example)

		return container

	}()
}
#endif
