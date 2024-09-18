//
//  CrewMemberView.swift
//  Moonshot
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import SwiftUI

struct CrewMemberView: View {
	let crewMember: MissionView.CrewMember

    var body: some View {
		HStack {
			Image(crewMember.astronaut.id)
				.resizable()
				.scaledToFit()
				.frame(width: 104, height: 72)
				.clipShape(.capsule)
				.overlay(
					Capsule()
						.strokeBorder(.white, lineWidth: 1)
				)

			VStack(alignment: .leading) {
				Text(crewMember.astronaut.name)
					.foregroundStyle(.white)
					.font(.headline)

				Text(crewMember.role)
					.foregroundStyle(.gray)
			}
		}
		.padding(.horizontal)
    }
}

#Preview {
	let mission = Mission.example
	let astronauts = Astronaut.allAstronauts
	let crewMembers = mission.crew.map { member in
		guard let astronaut = astronauts[member.name] else { fatalError("Missing \(member.name)") }

		return MissionView.CrewMember(role: member.role, astronaut: astronaut)
	}

	return ZStack {
		Color.darkBackground
			.ignoresSafeArea()
		CrewMemberView(crewMember: crewMembers.first!)
	}
	.preferredColorScheme(.dark)
}
