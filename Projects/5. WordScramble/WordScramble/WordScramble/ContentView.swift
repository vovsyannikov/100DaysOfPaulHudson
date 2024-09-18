//
//  ContentView.swift
//  WordScramble
//
//  Created by Виталий Овсянников on 09.07.2024.
//

import SwiftUI

struct ContentView: View {
	// MARK: State
	@State private var usedWords = [String]()
	@State private var rootWord = ""
	@State private var newWord = ""

	@State private var errorTitle = ""
	@State private var errorMessage = ""
	@State private var showingError = false

	// MARK: - Props
	private var currentScore: Int {
		usedWords.reduce(0, { $0 + $1.count })
	}

	var body: some View {
		NavigationStack {
			List {
				Section {
					TextField("Введите слово", text: $newWord)
						.textInputAutocapitalization(.never)
						.onSubmit(addNewWord)
				}

				Section {
					ForEach(usedWords, id: \.self) { word in
						HStack {
							countImage(for: word)
							Text(word)
								.font(.title2)
						}
					}
				} header: {
					Text("Текущий счёт: \(currentScore)")
						.font(.headline)
						.animation(.easeIn)
				}
			}
			.navigationTitle(rootWord)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Заново", action: startGame)
				}
			}
		}
		.onAppear(perform: startGame)
		.alert(errorTitle, isPresented: $showingError, actions: {}) {
			Text(errorMessage)
		}
	}

	// MARK: - Views
	private func countImage(for word: String) -> some View {
		var primaryColor = Color.primary
		let secondaryColor: Color =
		switch word.count {
		case 7...: .yellow
		case 6: .purple
		case 5: .blue
		case 4: .green

		default: .primary
		}

		var imageName = "\(word.count).circle"

		if secondaryColor != .primary {
			primaryColor = .white
			imageName.append(".fill")
		}

		return Image(systemName: imageName)
			.foregroundStyle(primaryColor, secondaryColor)
			.font(.system(size: 50))
	}

	// MARK: - Actions
	private func startGame() {
		guard let fileURL = Bundle.main.url(forResource: "words", withExtension: "txt")
		else { fatalError("Could not locate words.txt") }

		do {
			let words = try String(contentsOf: fileURL)
			let allWords = words.components(separatedBy: "\n")

			rootWord = allWords.randomElement() ?? "Завидово"
		} catch {
			print("Could not load words from words.txt: \(error.localizedDescription)")
		}
	}

	private func addNewWord() {
		let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

		do {
			try isHard(word: answer)
			try isOriginal(word: answer)
			try isPossible(word: answer)
			try isReal(word: answer)

			withAnimation {
				usedWords.insert(answer, at: 0)
			}
			newWord = ""
		} catch {
			showError(for: error as! WordError)
		}
	}

	// Validation
	private func isHard(word: String) throws {
		if word.count < 3 {
			throw WordError.tooShort
		}
	}

	private func isOriginal(word: String) throws {
		if word == rootWord.lowercased() {
			throw WordError.isRootWord
		}

		if usedWords.contains(word) == true {
			throw WordError.alreadyAdded
		}
	}

	private func isPossible(word: String) throws {
		var tempWord = rootWord.lowercased()

		for letter in word {
			guard let index = tempWord.firstIndex(of: letter)
			else { throw WordError.impossible(rootWord) }

			tempWord.remove(at: index)
		}
	}

	private func isReal(word: String) throws {
		let checker = UITextChecker()
		let range = NSRange(location: 0, length: word.utf16.count)

		let misspelledRange = checker.rangeOfMisspelledWord(
			in: word,
			range: range,
			startingAt: 0,
			wrap: false,
			language: "ru")

		if misspelledRange.location != NSNotFound {
			throw WordError.doesNotExist
		}
	}

	private func showError(for error: WordError) {
		errorTitle = error.failureReason ?? "Упс"
		errorMessage = error.errorDescription ?? "Что-то пошло не так"
		showingError = true
	}
}

// MARK: - WordError
enum WordError: LocalizedError {
	case alreadyAdded
	case doesNotExist
	case impossible(_ word: String)
	case isRootWord
	case tooShort

	var failureReason: String? {
		switch self {
		case .alreadyAdded:
			"Слово уже добавлено"

		case .doesNotExist:
			"Слово не опознано"

		case .impossible:
			"Невозможно сложить слово"

		case .isRootWord:
			"Это слово является ключевым"

		case .tooShort:
			"Слишком короткое слово"
		}
	}

	var errorDescription: String? {
		switch self {
		case .alreadyAdded:
			"Будьте оригинальней"

		case .doesNotExist:
			"Их нельзя выдумывать!"

		case .impossible(let word):
			"В слове '\(word)' не хватает букв"

		case .isRootWord:
			"Попробуйте что-нибудь другое"

		case .tooShort:
			"Найдите слово подлиннее"
		}
	}
}

// MARK: - Preview
#Preview {
	ContentView()
}
