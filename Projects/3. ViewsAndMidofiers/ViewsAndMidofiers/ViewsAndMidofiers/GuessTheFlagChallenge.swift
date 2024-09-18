//
//  GuessTheFlagChallenge.swift
//  ViewsAndModifiers
//
//  Created by Виталий Овсянников on 06.07.2024.
//
import SwiftUI

struct GuessTheFlagChallenge: View {
	// MARK: State
	@State private var countries: [(imageName: String, description: String)] = [
		("Estonia", "Эстонии"), ("France", "Франции"), ("Germany", "Германии"),
		("Ireland", "Ирландии"), ("Italy", "Италии"), ("Monaco", "Монако"),
		("Nigeria", "Нигерии"), ("Poland", "Польши"), ("Russia", "России"),
		("Spain", "Испании"), ("UK", "Великобритании"), ("US", "США")
	].shuffled()

	@State private var correctAnswer = Int.random(in: 0...2)
	@State private var showingScore = false
	@State private var endGameAlertShowing = false
	@State private var alertTitle = ""
	@State private var alertMessage = ""
	@State private var score = 0
	@State private var question = 0

	// MARK: - Props
	private let maxQuestions = 8
	private var gameEnded: Bool { maxQuestions == question }

	// MARK: - Body
	var body: some View {
		Form {
			NavigationLink(value: 1) {
				HStack {
					Image(systemName: "1.square.fill")
						.imageScale(.large)
						.foregroundStyle(.red)
					Text("Первый вид")
				}
			}
			NavigationLink(value: 2) {
				HStack {
					Image(systemName: "2.square.fill")
						.imageScale(.large)
						.foregroundStyle(.green)
					Text("Второй вид")
				}
			}
		}
		.navigationTitle("Угадай флаг")
		.navigationBarTitleDisplayMode(.inline)
		.navigationDestination(for: Int.self) { selectedView in
			Group {
				if selectedView == 1 {
					firstView
				} else {
					secondView
				}
			}
			.toolbarBackground(.visible, for: .navigationBar)
		}
		.alert(alertTitle, isPresented: $showingScore) {
			Button("Продолжить", action: askQuestion)
		} message: {
			Text(alertMessage)
		}
		.alert(alertTitle, isPresented: $endGameAlertShowing) {
			Button("Заново", action: restartGame)
		} message: {
			Text(alertMessage)
		}
	}

	// MARK: - Views
	private var firstView: some View {
		ZStack {
			LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
				.ignoresSafeArea()

			VStack(spacing: 30) {
				VStack {
					Text("Нажмите на флаг:")
						.foregroundStyle(.white)
						.font(.subheadline.weight(.heavy))

					Text(countries[correctAnswer].description)
						.foregroundStyle(.white)
						.font(.largeTitle.weight(.semibold))
				}

				ForEach(0..<3) { number in
					Button {
						flagTapped(number)
					} label: {
						FlagImage(imageName: countries[number].imageName)
					}
				}
			}
		}
	}

	private var secondView: some View {
		ZStack {
			RadialGradient(
				stops: [
					.init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
					.init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
				],
				center: .top,
				startRadius: 200,
				endRadius: 700
			)
			.ignoresSafeArea()

			VStack {
				Spacer()

				Text("Угадай флаг")
					.font(.largeTitle.bold())
					.foregroundStyle(.white)

				VStack(spacing: 15) {
					VStack {
						Text("Нажмите на флаг:")
							.foregroundStyle(.secondary)
							.font(.subheadline.weight(.heavy))

						Text(countries[correctAnswer].description)
							.foregroundStyle(.white)
							.font(.largeTitle.weight(.semibold))
					}

					ForEach(0..<3) { number in
						Button {
							flagTapped(number)
						} label: {
							FlagImage(imageName: countries[number].imageName)
						}
					}
				}
				.frame(maxWidth: .infinity)
				.padding(.vertical, 20)
				.background(.regularMaterial)
				.clipShape(.rect(cornerRadius: 20))

				Spacer()
				Spacer()

				Text("Текущий счёт: \(score)")
					.foregroundStyle(.white)
					.font(.title.bold())

				Spacer()
			}
			.padding()
		}
	}

	// MARK: - Actions
	private func flagTapped(_ number: Int) {
		question += 1

		if correctAnswer == number {
			alertTitle = "Верно"
			score += 1
			if gameEnded == false {
				askQuestion()
			}
		} else {
			alertTitle = "Не правильно"
			alertMessage = "Это флаг \(countries[number].description)"
			showingScore.toggle()
		}

		if gameEnded {
			alertTitle = "Игра закончена"
			alertMessage = "Вы ответили правильно на \(score)/\(maxQuestions) вопросов"
			endGameAlertShowing.toggle()
			return
		}
	}

	private func askQuestion() {
		countries.shuffle()
		correctAnswer = Int.random(in: 0...2)
	}

	private func restartGame() {
		question = 0
		score = 0

		askQuestion()
	}
}

// MARK: - FlagImage
struct FlagImage: View {
	let imageName: String

	var body: some View {
		Image(imageName)
			.clipShape(Capsule())
			.shadow(radius: 5)
	}
}

// MARK: - Preview
#Preview {
	NavigationStack {
		GuessTheFlagChallenge()
	}
}
