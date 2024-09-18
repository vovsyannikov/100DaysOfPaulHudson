//
//  ContentView.swift
//  UnitConverter
//
//  Created by Виталий Овсянников on 02.07.2024.
//

import SwiftUI

struct ContentView: View {
	@State private var selectedScreen = 1

	private var tint: Color {
		switch selectedScreen {
		case 2: return .yellow
		case 3: return .red
		default: return .green
		}
	}

	var body: some View {
		currentTabView
			.tint(tint)
	}

	@ViewBuilder
	private var tabView: some View {
		if #available(iOS 18, *) {
			newTabView
		} else {
			currentTabView
		}
	}

	@available(iOS 18.0, *)
	private var newTabView: some View {
		TabView(selection: $selectedScreen) {
			Tab("Верное решение", systemImage: "star.square", value: 1) {
				ActualSolutionStart()
			}

			Tab("Простое решение", systemImage: "1.square", value: 2) {
				SimpleSolution()
			}

			Tab("Сложное решение", systemImage: "2.square", value: 3) {
				ComplicatedSolution()
			}
		}
	}

	private var currentTabView: some View {
		TabView(selection: $selectedScreen) {
			ActualSolutionStart()
				.tag(1)
				.tabItem {
					Label("Верное решение", systemImage: "star.square")
				}

			SimpleSolution()
				.tag(2)
				.tabItem {
					Label("Простое решение", systemImage: "1.square")
				}

			ComplicatedSolution()
				.tag(3)
				.tabItem {
					Label("Сложное решение", systemImage: "2.square")
				}
		}
	}
}

#Preview {
	ContentView()
}
