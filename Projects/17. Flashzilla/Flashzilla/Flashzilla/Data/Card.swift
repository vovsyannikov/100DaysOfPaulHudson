//
//  Card.swift
//  Flashzilla
//
//  Created by Виталий Овсянников on 16.07.2024.
//

import Foundation

class CardStack {
	private init() {}

	private static let savePath = URL.documentsDirectory.appending(path: "Cards")

	static func loadCards() -> [Card] {
		guard let data = try? Data(contentsOf: savePath),
			  let decodedCards = try? JSONDecoder().decode([Card].self, from: data)
		else { return [] }

		return decodedCards
	}

	static func save(_ cards: [Card]) {
		guard let encodedCards = try? JSONEncoder().encode(cards) else { return }

		try? encodedCards.write(to: savePath, options: [.atomic])
	}
}

struct Card: Codable, Equatable, Identifiable {
	var id = UUID()

	var prompt: String
	var answer: String

	static func ==(lhs: Card, rhs: Card) -> Bool {
		lhs.id == rhs.id
	}
}

// MARK: - Examples
extension Card {
	static let example = Card(prompt: "Кто был первым президентом Российской Федерации?", answer: "Борис Ельцин")
}

