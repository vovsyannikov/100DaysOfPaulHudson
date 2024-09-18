//
//  Book.swift
//  Bookworm
//
//  Created by Виталий Овсянников on 12.07.2024.
//

import Foundation
import SwiftData

@Model
final class Book {
	static let noTitle = "Не указано"
	static let noAuthor = "Не указан"

	var title: String
	var author: String
	var genre: Genre
	var review = ""
	var rating: Int
	var readDate = Date.now

	var hasTitle: Bool { title != Self.noTitle }
	var hasAuthor: Bool { author != Self.noAuthor }
	var hasReview: Bool { review.isEmpty == false }

	init(title: String, author: String, genre: Genre, review: String = "", rating: Int, readDate: Foundation.Date = Date.now) {
		self.title = title
		self.author = author
		self.genre = genre
		self.review = review
		self.rating = rating
		self.readDate = readDate
	}
}

// MARK: - Genre
extension Book {
	enum Genre: String, CaseIterable, Codable, Identifiable {
		var id: RawValue { rawValue }

		case fantasy = "Фантастика"
		case horror = "Ужасы"
		case kids = "Для детей"
		case mystery = "Детектив"
		case poetry = "Поезия"
		case romance = "Роман"
		case thriller = "Триллер"

		var image: String {
			let image = switch self {
				case .fantasy: "fantasy"
				case .horror: "horror"
				case .kids: "kids"
				case .mystery: "mystery"
				case .poetry: "poetry"
				case .romance: "romance"
				case .thriller: "thriller"
			}

			return image.localizedCapitalized
		}
	}
}

// MARK: - Sample Data
extension Book {
	@MainActor
	static func createSampleData(in container: ModelContainer) {
		let now = Date.now
		let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now) ?? now
		let twoYearsAgo = Calendar.current.date(byAdding: .year, value: -2, to: now) ?? now

		let templateBook = Book(
			title: "Название книги",
			author: "Имя Автора",
			genre: .fantasy,
			review: "Небольшой пример отзыва для книги",
			rating: 4,
			readDate: yesterday
		)

		let badReview = "Кто такое вообще мог написать, Это просто ужасно. "
		+ "Я чуть не откинул кони, пока читал этот набор букв"

		let badBook = Book(
			title: "Плохая книга",
			author: "Посредственный Автор",
			genre: .horror,
			review: badReview,
			rating: 1
		)

		let emptyBook = Book(
			title: Book.noTitle,
			author: Book.noAuthor,
			genre: .fantasy,
			rating: 2,
			readDate: twoYearsAgo
		)

		container.mainContext.insert(templateBook)
		container.mainContext.insert(badBook)
		container.mainContext.insert(emptyBook)
	}
}
