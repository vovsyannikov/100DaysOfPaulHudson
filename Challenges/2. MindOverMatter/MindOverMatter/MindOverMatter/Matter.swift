//
//  Matter.swift
//  MindOverMatter
//
//  Created by Виталий Овсянников on 07.07.2024.
//

import Foundation

enum Matter: String, CaseIterable, Identifiable {
	case rock = "Камень"
	case scissors = "Ножницы"
	case paper = "Бумага"

	var id: String { rawValue }

	func wins(over matter: Matter) -> Bool {
		switch (self, matter) {
			case (.rock, .scissors), (.scissors, .paper), (.paper, .rock):
				return true

			default:
				return false
		}
	}

	var icon: String {
		switch self {
			case .rock: "🪨"
			case .scissors: "✂️"
			case .paper: "📃"
		}
	}
}
