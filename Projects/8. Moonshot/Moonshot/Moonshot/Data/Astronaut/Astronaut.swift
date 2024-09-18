//
//  Astronaut.swift
//  Moonshot
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import Foundation

struct Astronaut: Codable, Identifiable, Hashable {
	let id: String
	let name: String
	let description: String
}

extension Astronaut {
	static let allAstronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
	static func example(for name: String) -> Astronaut {
		allAstronauts[name]!
	}
}
