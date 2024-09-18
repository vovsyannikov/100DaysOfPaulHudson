//
//  Mission.swift
//  Moonshot
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import Foundation

struct Mission: Codable, Identifiable, Hashable {
	let id: Int
	let launchDate: Date?
	let crew: [CrewRole]
	let description: String

	var displayName: String {
		"Apollo \(id)"
	}

	var image: String {
		"apollo\(id)"
	}

	var formattedLaunchDate: String {
		launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
	}
}

extension Mission {
	struct CrewRole: Codable, Hashable {
		let name: String
		let role: String
	}
}

extension Mission {
	static let allMissions: [Mission] = Bundle.main.decode("missions.json")
	static let example: Mission = allMissions.first!
}
