//
//  ContentView.swift
//  Animations
//
//  Created by Виталий Овсянников on 09.07.2024.
//

import SwiftUI

struct ContentView: View {
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

	@State private var path = [1]
	@State private var selectedFlag: Int?

	// MARK: - Props
	private let maxQuestions = 8
	private var gameEnded: Bool { maxQuestions == question }

	private let chosenAnimation = Animation.bouncy
	private let remainingAnimation = Animation.easeOut

	// MARK: - Body
	var body: some View {
		NavigationStack(path: $path) {
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
					button(for: number)
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
						button(for: number)
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
		.onTapGesture {
			flagTapped(nil)
		}
	}

	private func button(for countryIndex: Int) -> some View {
		Button {
			flagTapped(countryIndex)
		} label: {
			flagImage(for: countryIndex)
		}
	}

	private func flagImage(for countryIndex: Int) -> some View {
		FlagImage(imageName: countries[countryIndex].imageName)
			.overlay {
				if selectedFlag == countryIndex {
					selectionView(for: countryIndex)
				}
			}
			.rotation3DEffect(flagRotation(for: countryIndex), axis: (0, 1, 0))
			.scaleEffect(flagScale(for: countryIndex))
			.opacity(flagOpacity(for: countryIndex))
			.animation(.bouncy, value: selectedFlag)
	}

	private func selectionView(for countryIndex: Int) -> some View {
		ZStack {
			Capsule()
				.fill(countryIndex == correctAnswer ? .green : .red)
				.opacity(0.75)

			Group {
				if countryIndex == correctAnswer {
					Image(systemName: "checkmark")
				} else {
					VStack(spacing: 10) {
						Image(systemName: "xmark")
						Text("Флаг \(countries[countryIndex].description)")
							.font(.title2)
					}
				}
			}
			.font(.title2.bold())
			.foregroundStyle(.white)
		}
	}

	// MARK: - Actions
	private func flagTapped(_ number: Int?) {
		withAnimation {
			if let selectedFlag {
				processFlag(selectedFlag)
				self.selectedFlag = nil
			} else {
				selectedFlag = number
			}
		}
	}

	private func processFlag(_ number: Int) {
		if correctAnswer == number {
			score += 1
		}

		question += 1

		if gameEnded {
			alertTitle = "Игра закончена"
			alertMessage = "Вы ответили правильно на \(score)/\(maxQuestions) вопросов"
			endGameAlertShowing.toggle()
			return
		}

		askQuestion()
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

	// MARK: - Props w/Params


	private func flagRotation(for number: Int) -> Angle {
		.degrees(selectedFlag == number ? 360 : 0)
	}

	private func flagScale(for number: Int) -> Double {
		guard let selectedFlag else { return 1 }

		return selectedFlag == number ? 1.0 : 0.75
	}

	private func flagOpacity(for number: Int) -> Double {
		guard let selectedFlag else { return 1 }

		return selectedFlag == number ? 1.0 : 0.5
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

#Preview {
	ContentView()
}
