//
//  MissionTitleView.swift
//  Moonshot
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import SwiftUI

struct MissionTitleView: View {
	let mission: Mission

	var body: some View {
		VStack {
			Image(mission.image)
				.resizable()
				.scaledToFit()
				.frame(width: 100, height: 100)
				.padding()

			VStack {
				Text(mission.displayName)
					.font(.headline)
					.foregroundStyle(.white)

				Text(mission.formattedLaunchDate)
					.font(.caption)
					.foregroundStyle(.gray)
			}
			.padding(.vertical)
			.frame(maxWidth: .infinity)
			.background(.lightBackground)
		}
		.clipShape(.rect(cornerRadius: 10))
		.overlay(
			RoundedRectangle(cornerRadius: 10)
				.stroke(.lightBackground)
		)
	}
}

#Preview {
	ZStack {
		Color.darkBackground
			.ignoresSafeArea()
		MissionTitleView(mission: .example)
			.preferredColorScheme(.dark)
	}
}
