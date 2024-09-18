//
//  ContentView.swift
//  Moonshot
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import SwiftUI

struct ContentView: View {
	@Namespace private var moonshot

	// MARK: - State
	@State private var selectedMission: Mission?
	@State private var showAsList = false

	// MARK: - Props
	private let astronauts = Astronaut.allAstronauts
	private let missions = Mission.allMissions

	private let layout = [
		GridItem(.adaptive(minimum: 150))
	]

	private let grid: (title: String, image: String) = ("Grid View", "square.grid.2x2")
	private let list: (title: String, image: String) = ("List View", "list.bullet")


	// MARK: - Body
    var body: some View {
		NavigationStack {
			content
				.navigationTitle("Moonshot")
				.navigationDestination(for: Mission.self) { mission in
					MissionView(mission: mission, astronauts: astronauts)
				}
				.navigationDestination(for: Astronaut.self, destination: AstronautView.init)
		}
    }

	// MARK: - Subviews
	private var content: some View {
		ScrollView {
			if showAsList {
				listView
			} else {
				gridView
			}
		}
		.background(.darkBackground)
		.preferredColorScheme(.dark)
		.animation(.default, value: showAsList)
		.toolbar {
			Menu {
				Picker("View", selection: $showAsList) {
					Button(grid.title, systemImage: grid.image) {
						showAsList = false
					}
					.tag(false)

					Button(list.title, systemImage: list.image) {
						showAsList = true
					}
					.tag(true)
				}
			} label: {
				Label(showAsList ? grid.title : list.title,
					  systemImage: showAsList ? grid.image : list.image)
			} primaryAction: {
				showAsList.toggle()
			}
		}
	}

	private var gridView: some View {
		LazyVGrid(columns: layout) {
			ForEach(missions) { mission in
				NavigationLink(value: mission) {
					MissionTitleView(mission: mission)
						.matchedGeometryEffect(id: mission.id, in: moonshot)
				}
			}
		}
		.padding([.horizontal, .bottom])
	}

	private var listView: some View {
		ForEach(missions) { mission in
			NavigationLink(value: mission) {
				MissionTitleView(mission: mission)
					.matchedGeometryEffect(id: mission.id, in: moonshot)
					.padding(.horizontal)
			}
		}
	}

	private var iPadView: some View {
		NavigationSplitView {
			content
		} detail: {
			NavigationStack {
				if let selectedMission {
					MissionView(mission: selectedMission, astronauts: astronauts)
				} else {
					ContentUnavailableView("Please select mission form the sidebar",
										   systemImage: "exclamationmark.triangle.fill")
					.foregroundStyle(.primary, .yellow)
					.background(.darkBackground)
				}
			}
		}
	}
}

// MARK: - Preview
#Preview {
    ContentView()
}

extension Array {
	func reduce<Result>(_ update: (_ partialResult: Result?, Element) -> Result) -> Result? {
		var temp: Result?

		for el in self {
			temp = update(temp, el)
		}

		return temp
	}
}
