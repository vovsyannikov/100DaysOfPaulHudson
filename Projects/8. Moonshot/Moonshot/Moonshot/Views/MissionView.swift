//
//  MissionView.swift
//  Moonshot
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import SwiftUI

struct MissionView: View {
	// MARK: Props
	let mission: Mission
	let crew: [CrewMember]

	// MARK: - Initializer
	init(mission: Mission, astronauts: [String: Astronaut]) {
		self.mission = mission
		self.crew = mission.crew.map { member in
			guard let astronaut = astronauts[member.name] else { fatalError("Missing \(member.name)") }

			return CrewMember(role: member.role, astronaut: astronaut)
		}
	}

	// MARK: - Body
    var body: some View {
		ScrollView {
			VStack {
				image

				launchDate

				description
					.padding(.horizontal)

				crewView
			}
			.padding(.bottom)
		}
		.navigationTitle(mission.displayName)
		.navigationBarTitleDisplayMode(.inline)
		.background(.darkBackground)
    }

	// MARK: - Subviews
	private var image: some View {
		Image(mission.image)
			.resizable()
			.scaledToFit()
			.containerRelativeFrame(.vertical) { height, _ in
				height * 0.3
			}
	}

	private var launchDate: some View {
		VStack(alignment: .leading) {
			divider

			Title("Launch Date:")

			Text(mission.launchDate?.formatted(date: .long, time: .omitted) ?? "N/A")
				.font(.title3)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.horizontal)
	}

	private var description: some View {
		VStack(alignment: .leading) {
			divider

			Title("Mission highlights")

			Text(mission.description)

			divider

			Title("Crew")
		}
	}

	private var crewView: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack {
				ForEach(crew, id: \.role) { crewMember in
					NavigationLink(value: crewMember.astronaut) {
						CrewMemberView(crewMember: crewMember)
					}
				}
			}
		}
	}

	private var divider: some View {
		Rectangle()
			.frame(height: 2)
			.foregroundStyle(.lightBackground)
			.padding(.vertical)
	}
}

// MARK: - Extensions
extension MissionView {
	struct CrewMember: Hashable {
		let role: String
		let astronaut: Astronaut
	}
}

// MARK: - Preview
#Preview {
	NavigationStack {
		MissionView(mission: .allMissions[2], astronauts: Astronaut.allAstronauts)
			.preferredColorScheme(.dark)
	}
}
