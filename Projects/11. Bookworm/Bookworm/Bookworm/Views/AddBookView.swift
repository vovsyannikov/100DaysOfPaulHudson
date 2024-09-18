//
//  AddBookView.swift
//  Bookworm
//
//  Created by Виталий Овсянников on 12.07.2024.
//

import SwiftUI

struct AddBookView: View {
	// MARK: Environment
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss

	// MARK: - States
	@State private var title = ""
	@State private var author = ""
	@State private var genre = Book.Genre.fantasy
	@State private var review = ""
	@State private var rating = 3
	@State private var readDate = Date.now

	// MARK: - Body
	var body: some View {
		NavigationStack {
			Form {
				Section {
					TextField("Название", text: $title)
					TextField("Автор", text: $author)

					Picker("Жанр", selection: $genre) {
						ForEach(Book.Genre.allCases) { genre in
							Text(genre.rawValue)
								.tag(genre)
						}
					}
				}

				Section("Напишите отзыв") {
					TextEditor(text: $review)
					DatePicker("Дата прочтения", selection: $readDate, in: ...Date.now)
					RatingView(rating: $rating)
				}

				Section {
					Button("Сохранить", action: save)
				}
			}
			.navigationTitle("Добавить книгу")
		}
	}

	private func save() {
		let title = title.isEmpty ? Book.noTitle : title
		let author = author.isEmpty ? Book.noAuthor : author

		let newBook = Book(
			title: title,
			author: author,
			genre: genre,
			review: review,
			rating: rating,
			readDate: readDate
		)

		modelContext.insert(newBook)

		dismiss()
	}
}

#Preview {
    AddBookView()
}
