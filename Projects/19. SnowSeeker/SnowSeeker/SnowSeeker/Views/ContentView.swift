//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Виталий Овсянников on 18.07.2024.
//

import OSLog
import SwiftUI

struct ContentView: View {
	// MARK: State
	@State private var favorites = Favorites()
	@State private var searchText = ""
	@State private var sort = Resort.Sort.byCountry

	// MARK: - Props
	private let resorts: [Resort] = Bundle.main.decode("resorts.json")
	private var filteredResorts: [Resort] {
		if searchText.isEmpty {
			resorts
		} else {
			resorts.filter { $0.name.localizedStandardContains(searchText) }
		}
	}
	private var sortedResults: [Resort] {
		switch sort {
		case .default:
			filteredResorts

		case .alphabetical:
			filteredResorts.sorted(by: { $0.name < $1.name })

		case .byCountry:
			filteredResorts.sorted {
				if $0.country == $1.country {
					return $0.name < $1.name
				}

				return $0.country < $1.country
			}
		}
	}

	// MARK: - Body
    var body: some View {
		NavigationSplitView {
			resortsList
		} detail: {
			WelcomeView()
		}
		.environment(favorites)
    }

	// MARK: - Subviews
	private var resortsList: some View {
		List(sortedResults) { resort in
			let isFavorite = favorites.contains(resort)
			var favoritesInfo: (title: String, image: String) {
				let title = isFavorite ? "Remove from Favorites" : "Add to Favorites"
				let image = isFavorite ? "star.slash" : "star.fill"

				return (title, image)
			}

			NavigationLink(value: resort) {
				HStack {
					image(for: resort)
					description(for: resort)
					if favorites.contains(resort) {
						Spacer()

						favoriteImage(for: resort)
					}
				}
			}
			.swipeActions(edge: .leading) {
				Button(favoritesInfo.title, systemImage: favoritesInfo.image) {
					isFavorite ? favorites.remove(resort) : favorites.add(resort)
				}
				.tint(isFavorite ? .blue : .yellow)
			}
		}
		.navigationTitle("Resorts")
		.navigationDestination(for: Resort.self) { resort in
			ResortView(resort: resort)
		}
		.searchable(text: $searchText, prompt: "Search for a resort")
		.toolbar {
			Menu("Sort", systemImage: "line.3.horizontal.decrease.circle") {
				Picker("Sorting", selection: $sort) {
					ForEach(Resort.Sort.allCases) { sort in
						Text(sort.rawValue)
							.tag(sort)
					}
				}
				.pickerStyle(.inline)
			}
		}
	}

	private func image(for resort: Resort) -> some View {
		Image(resort.country)
			.resizable()
			.scaledToFit()
			.frame(height: 25)
			.clipShape(.rect(cornerRadius: 5))
			.overlay(
				RoundedRectangle(cornerRadius: 5)
					.stroke(.black, lineWidth: 1)
			)
	}

	private func description(for resort: Resort) -> some View {
		VStack(alignment: .leading) {
			Text(resort.name)
				.font(.headline)

			Text("\(resort.runs) runs")
				.foregroundStyle(.secondary)
		}
	}

	private func favoriteImage(for resort: Resort) -> some View {
		Image(systemName: "star.fill")
			.foregroundStyle(.yellow)
			.shadow(radius: 2)
	}
}

// MARK: - Previews
#Preview {
    ContentView()
}
