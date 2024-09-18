//
//  EditView-ViewModel.swift
//  Flashzilla
//
//  Created by Виталий Овсянников on 16.07.2024.
//

import Foundation

extension EditView {
	@Observable
	final class ViewModel {
		private(set) var cards: [Card] {
			didSet { CardStack.save(cards) }
		}

		var newPrompt = ""
		var newAnswer = ""

		var cardCount: Int {
			cards.count
		}

		private let savePath = URL.documentsDirectory.appending(path: "Cards")

		init() {
			cards = CardStack.loadCards()
		}

		func addCard() {
			let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
			let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespacesAndNewlines)

			guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false
			else { return }

			let newCard = Card(prompt: trimmedPrompt, answer: trimmedAnswer)

			cards.insert(newCard, at: 0)

			newPrompt = ""
			newAnswer = ""
		}

		func removeCards(at offsets: IndexSet) {
			cards.remove(atOffsets: offsets)
		}
	}
}
