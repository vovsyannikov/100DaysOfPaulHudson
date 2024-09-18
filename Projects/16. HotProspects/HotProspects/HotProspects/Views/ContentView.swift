//
//  ContentView.swift
//  HotProspects
//
//  Created by Виталий Овсянников on 16.07.2024.
//

import SwiftUI

struct ContentView: View {
	typealias Filter = Prospect.FilterType

	// MARK: - Body
    var body: some View {
		TabView {
			ProspectsView(filter: .all)
				.tabItem { Label(Filter.all.title, systemImage: "person.3") }

			ProspectsView(filter: .contacted)
				.tabItem { Label(Filter.contacted.title, systemImage: "checkmark.circle") }

			ProspectsView(filter: .noContact)
				.tabItem { Label(Filter.noContact.title, systemImage: "questionmark.diamond") }

			MeView()
				.tabItem { Label("Я", systemImage: "person.crop.square") }
		}
    }
}

// MARK: - Previews
#Preview {
    ContentView()
		.modelContainer(Prospect.container)
}
