//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Виталий Овсянников on 18.07.2024.
//

import SwiftUI

struct ResortView: View {
	// MARK: State
	@Environment(\.dynamicTypeSize) private var dynamicTypeSize
	@Environment(\.horizontalSizeClass) private var hSizeClass

	@Environment(Favorites.self) var favorites

	@State private var selectedFacility: Resort.Facility?
	@State private var showingFacility = false

	let resort: Resort
	private var isFavorite: Bool { favorites.contains(resort) }
	private var favoritesInfo: (title: String, image: String) {
		let title = isFavorite ? "Remove from Favorites" : "Add to Favorites"
		let image = isFavorite ? "star.fill" : "star"

		return (title, image)
	}

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 0) {
				Image(decorative: resort.id)
					.resizable()
					.scaledToFit()

				HStack {
					if hSizeClass == .compact && dynamicTypeSize > .xLarge {
						VStack(spacing: 10) { ResortDetailsView(resort: resort) }
						VStack(spacing: 10) { SkiDetailsView(resort: resort) }
					} else {
						ResortDetailsView(resort: resort)
						SkiDetailsView(resort: resort)
					}
				}
				.padding(.vertical)
				.background(.primary.opacity(0.1))

				Group {
					Text(resort.description)
						.padding(.vertical)

					Text("Facilities")
						.font(.headline)

					HStack {
						ForEach(resort.facilities) { facility in
							Button {
								selectedFacility = facility
								showingFacility = true
							} label: {
								facility.icon
									.font(.title)
							}
						}
					}
					.confirmationDialog(selectedFacility?.description ?? "More info", isPresented: $showingFacility, presenting: selectedFacility, actions: { _ in }) { facility in
						Text(facility.description)
					}
					.padding(.vertical)
				}
				.padding(.horizontal)
			}
		}
		.navigationTitle("\(resort.name), \(resort.country)")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			Button(favoritesInfo.title, systemImage: favoritesInfo.image) {
				isFavorite ? favorites.remove(resort) : favorites.add(resort)
			}
			.tint(isFavorite ? .yellow : .blue)
		}
	}
}

#Preview {
	NavigationStack {
		ResortView(resort: .example)
			.environment(Favorites())
	}
}
