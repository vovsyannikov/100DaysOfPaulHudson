//
//  ContentView.swift
//  Flashzilla
//
//  Created by Виталий Овсянников on 16.07.2024.
//

import SwiftUI

struct ContentView: View {
	// MARK: State
	@Environment(\.accessibilityDifferentiateWithoutColor) private var withoutColor
	@Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled
	@Environment(\.scenePhase) private var scenePhase

	@State private var initialCards = [Card]()
	@State private var cards = [Card]()
	@State private var isActive = true
	@State private var timeRemaining = 100
	@State private var showingEditScreen = false

	// MARK: - Props
	private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

	private	var lastCardIndex: Int { cards.count - 1 }

	// MARK: - Body
    var body: some View {
		ZStack {
			Image(decorative: "background")
				.resizable()
				.ignoresSafeArea()

			if initialCards.isEmpty {
				noCardsView
			} else {
				gameView
			}
		}
		.sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditView.init)
		.onAppear(perform: startGame)
		.onChange(of: scenePhase) {
			if cards.isEmpty { return }

			isActive = scenePhase == .active
		}
		.onReceive(timer) { time in
			guard isActive else { return }

			if timeRemaining > 0 {
				timeRemaining -= 1
			}
		}
    }

	// MARK: - Subviews
	private var noCardsView: some View {
		Button {
			showingEditScreen = true
		} label: {
			Label("Добавить первую карточку", systemImage: "plus")
				.symbolVariant(.circle)
				.foregroundStyle(.white)
				.font(.largeTitle)
				.padding()
				.background(.black.opacity(0.7))
				.clipShape(.capsule)
		}
	}

	@ViewBuilder
	private var gameView: some View {
		VStack {
			timerView

			cardStack
				.allowsHitTesting(timeRemaining > 0)

			if cards.isEmpty {
				Button("Начать сначала", action: resetCards)
					.padding()
					.background(.white)
					.foregroundStyle(.black)
					.clipShape(.capsule)
			}
		}

		editButtonView

		if withoutColor || voiceOverEnabled {
			accessibilityIcons
		}
	}

	private var timerView: some View {
		Text("Время: \(timeRemaining)")
			.font(.largeTitle)
			.foregroundStyle(.white)
			.padding(.horizontal, 20)
			.padding(.vertical, 5)
			.background(.black.opacity(0.75))
			.clipShape(.capsule)
	}

	private var cardStack: some View {
		ZStack {
			ForEach(0..<cards.count, id: \.self) { index in
				CardView(card: cards[index])
					.onRemove { offset in
						removeCard(at: index, wrong: offset < 0)
					}
					.stacked(at: index, in: cards.count)
					.allowsHitTesting(index == lastCardIndex)
					.accessibilityHidden(index < lastCardIndex)
			}
		}
	}

	private var accessibilityIcons: some View {
		VStack {
			Spacer()

			HStack {
				circleButton(for: .wrongAnswer) { removeCard(at: lastCardIndex, wrong: true) }

				Spacer()

				circleButton(for: .correctAnswer) { removeCard(at: lastCardIndex, wrong: false) }
			}
			.padding()
		}
	}

	private func circleButton(for type: ButtonType, action: @escaping () -> Void) -> some View {
		Button(action: action) {
			Image(systemName: type.image)
				.symbolVariant(.circle)
				.foregroundStyle(.white)
				.font(.largeTitle)
				.padding()
				.background(.black.opacity(0.7))
				.clipShape(.circle)
		}
		.accessibilityLabel(type.accessibilityInfo.title)
		.accessibilityHint(type.accessibilityInfo.hint)
	}

	private var editButtonView: some View {
		VStack {
			HStack {
				Spacer()

				circleButton(for: .edit) { showingEditScreen = true }
			}

			Spacer()
		}
		.padding()
	}

	// MARK: - Actions
	private func startGame() {
		resetCards()
		isActive = cards.isEmpty == false
	}

	private func resetCards() {
		withAnimation {
#if DEBUG
			initialCards = [Card.example, Card(prompt: "Prompt", answer: "Answer")]
			cards = initialCards
#else
			if initialCards.isEmpty {
				initialCards = CardStack.loadCards()
			}
			cards = CardStack.loadCards()
#endif
			timeRemaining = 100
			isActive = true
		}
	}

	private func removeCard(at index: Int, wrong: Bool) {
		guard index >= 0 else { return }

		withAnimation {
			cards.remove(at: index)

			if cards.isEmpty {
				isActive = false
			}
		}
	}
}

// MARK: - Button Type
extension ContentView {
	enum ButtonType {
		case correctAnswer
		case wrongAnswer
		case edit

		var image: String {
			switch self {
				case .correctAnswer: "checkmark"
				case .wrongAnswer: 	 "xmark"
				case .edit:			 "plus"
			}
		}

		var accessibilityInfo: (title: String, hint: String) {
			switch self {
				case .correctAnswer: ("Правильно", "Отметить ответ как правильный")
				case .wrongAnswer: 	 ("Не правильно", "Отметить ответ как неправильный")
				case .edit:			 ("Добавить карточку", "Создать новую карточку для игры")
			}
		}
	}
}

// MARK: - Previews
#Preview(traits: .landscapeLeft) {
    ContentView()
}
