//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Виталий Овсянников on 06.07.2024.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		NavigationStack {
			VStack(spacing: 30) {
				NavigationLink(value: Challenge.weSplit) {
					linkView(name: "Делись",
							 description: "Красный цвет у суммы заказа при чаевых == 0",
							 color: .orange) {
						Text("₽")
					}
				}

				NavigationLink(value: Challenge.guessTheFlag) {
					linkView(name: "Угадай флаг",
							 description: "Выделение отдельного вида для кнопки флага",
							 color: .indigo) {
						Text("🇷🇺")
					}
				}

				NavigationLink(value: Challenge.viewModifier) {
					linkView(name: "Модификаторы",
							 description: "Новый модификатор для большого синего заголовка",
							 color: .green) {
						Image(systemName: "gear")
					}
				}
			}
			.navigationTitle("Задания")
			.navigationDestination(for: Challenge.self) { challenge in
				switch challenge {
				case .weSplit:
					WeSplitChallengeView()

				case .guessTheFlag:
					GuessTheFlagChallenge()

				case .viewModifier:
					ViewModifierChallenge()
				}
			}
			.padding(.horizontal)
		}
	}

	private func linkView<I: View>(name: String, description: String = "", color: Color, icon: () -> I) -> some View {
		VStack {
			icon()
				.font(.largeTitle)
				.frame(maxWidth: .infinity)

			Text(name)
				.font(.title)

			Text(description)
				.font(.caption.bold())
		}
		.tint(.white)
		.padding()
		.background(color.gradient)
		.clipShape(.rect(cornerRadius: 15))
	}
}

extension ContentView {
	enum Challenge {
		case weSplit
		case guessTheFlag
		case viewModifier
	}
}

#Preview {
	ContentView()
}
