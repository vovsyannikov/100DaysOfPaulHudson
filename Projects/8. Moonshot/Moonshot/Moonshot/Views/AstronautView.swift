//
//  AstronautView.swift
//  Moonshot
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import SwiftUI

struct AstronautView: View {
	@State private var path = NavigationPath()
	@State private var fitImage = true

	let astronaut: Astronaut

	// MARK: - Body
    var body: some View {
		ScrollView {
			VStack {
				Image(astronaut.id)
					.resizable()
					.scaledToFit()
					.containerRelativeFrame(.vertical) { size, _ in
						fitImage ? size * 0.4 : size
					}
					.onTapGesture(count: 2) {
						withAnimation {
							fitImage.toggle()
						}
					}

				Text(astronaut.description)
					.padding()
			}
		}
		.navigationTitle(astronaut.name)
		.navigationBarTitleDisplayMode(.inline)
		.background(.darkBackground)
	}
}

#Preview {
	NavigationStack {
		AstronautView(astronaut: .example(for: "armstrong"))
			.preferredColorScheme(.dark)
	}
}
