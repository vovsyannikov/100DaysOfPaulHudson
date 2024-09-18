//
//  ContentView.swift
//  MindOverMatter
//
//  Created by Виталий Овсянников on 06.07.2024.
//

import SwiftUI

struct ContentView: View {
	@Namespace private var game

	// MARK: - State
	@State private var showTutorial = true

	@State private var currentMatter = Matter.paper
	@State private var win = true

	@State private var options = Matter.allCases

	@State private var score = 0

	@State private var currentQuestion = 0
	@State private var gameEnded = false

	// MARK: - Props
	private let winIcon = "checkmark.square.fill"
	private let loseIcon = "xmark.square.fill"
	private var currentIcon: String {
		win ? winIcon : loseIcon
	}
	private var currentColor: Color {
		win ? .green : .red
	}

	private let maxQuestions = 10

	private let opponentID = "Opponent"
	private let optionsID = "Options"

	// MARK: - Body
	var body: some View {
		NavigationStack {
			ZStack {
				backgroundView

				if showTutorial {
					tutorialView
				} else {
					gameView
				}
			}
			.navigationTitle(showTutorial ? "Битва Разума" : "Счёт: \(score)")
			.preferredColorScheme(.dark)
			.alert("Конец игры", isPresented: $gameEnded) {
				Button("Начать заново", action: resetGame)
			} message: {
				Text("Итоговый счёт: \(score)/\(maxQuestions)")
			}
		}
	}

	// MARK: - Views
	private var backgroundView: some View {
		LinearGradient(
			colors: [.indigo, .blue, .mint, .green],
			startPoint: .topLeading,
			endPoint: .bottomTrailing
		)
		.ignoresSafeArea()
		.brightness(showTutorial ? -0.4 : 0)
	}

	private var tutorialView: some View {
		VStack(alignment: .leading, spacing: 15) {
			Text("Добро пожаловать!")
				.font(.title.bold())
				.frame(maxWidth: .infinity)

			Text("Цель игры: выбрать правильный вариант исхода игры Камень, Ножницы, Бумага")

			Text("Вот так выглядит условие:")

			opponentView
				.frame(maxWidth: .infinity)
				.matchedGeometryEffect(id: opponentID, in: game)

			VStack(alignment: .leading) {
				HStack {
					Image(systemName: winIcon)
						.foregroundStyle(.white, .green)

					Text("Победный вариант")
				}

				HStack {
					Image(systemName: loseIcon)
						.foregroundStyle(.white, .red)

					Text("Проигрышный вариант")
				}
			}

			Text("Нажмите на вариант ответа для начала")

			optionsView
				.matchedGeometryEffect(id: optionsID, in: game)
		}
		.padding()
	}

	private var gameView: some View {
		VStack {
			Spacer()

			opponentView
				.frame(maxWidth: .infinity)
				.matchedGeometryEffect(id: opponentID, in: game)

			Spacer()

			optionsView
				.matchedGeometryEffect(id: optionsID, in: game)
		}
		.padding()
	}

	private var opponentView: some View {
		VStack(spacing: 10) {
			Text(currentMatter.icon)
				.font(.system(size: showTutorial ? 100 : 300))
				.minimumScaleFactor(0.5)

			Image(systemName: currentIcon)
				.foregroundStyle(.white, currentColor)
				.font(.system(size: 30))
		}
		.padding()
		.background(.ultraThinMaterial)
		.background(currentColor)
		.clipShape(.rect(cornerRadius: 10))
	}

	private var optionsView: some View {
		HStack {
			ForEach(options) {
				Spacer()
				matterView(for: $0)
			}
			Spacer()
		}
	}

	private func matterView(for matter: Matter) -> some View {
		Button {
			tapped(matter)
		} label: {
			VStack {
				Text(matter.icon)
					.font(.system(size: 75))
					.minimumScaleFactor(0.3)

				Text(matter.rawValue)
					.fontWeight(.light)
			}
			.padding(5)
			.frame(maxWidth: .infinity)
			.background(.regularMaterial)
			.clipShape(.rect(cornerRadius: 10))
			.colorScheme(.light)
		}
		.tint(.primary)
		.transition(.opacity)
	}

	// MARK: - Actions
	private func tapped(_ matter: Matter) {
		withAnimation {
			if showTutorial {
				showTutorial = false
			}

			let increaseScore = win
			? matter.wins(over: currentMatter)
			: currentMatter.wins(over: matter)

			if increaseScore {
				score += 1
			} else if score > 0 {
				score -= 1
			}

			currentQuestion += 1
			if currentQuestion == maxQuestions {
				gameEnded = true
				return
			}

			options.shuffle()
			currentMatter = .allCases.randomElement()!
			win = Bool.random()
		}
	}

	private func resetGame() {
		withAnimation {
			score = 0
			currentQuestion = 0
			options.shuffle()
			currentMatter = .allCases.randomElement()!
			win = Bool.random()
		}
	}
}

#Preview {
	ContentView()
}
