//
//  DetailView.swift
//  Bookworm
//
//  Created by Виталий Овсянников on 12.07.2024.
//

import SwiftData
import SwiftUI

struct DetailView: View {
	// MARK: State
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext

	@State private var showingDeleteAlert = false

	let book: Book

	private var review: String {
		book.hasReview ? book.review : "Отзыв отсутствует"
	}

	// MARK: - Body
    var body: some View {
		ScrollView {
			image
			bookDetails
		}
		.navigationTitle(book.title)
		.navigationBarTitleDisplayMode(.inline)
		.scrollBounceBehavior(.basedOnSize)
		.toolbar {
			ToolbarItem(placement: .destructiveAction) {
				Button("Удалить", systemImage: "trash", role: .destructive, action: showDeleteAlert)
					.buttonStyle(.borderless)
			}
		}
		.alert("Удалить книгу", isPresented: $showingDeleteAlert) {
			Button("Удалить", role: .destructive, action: deleteBook)
			Button("Отмена", role: .cancel) {}
		} message: {
			Text("Вы уверены?")
		}
    }

	// MARK: - Subviews
	private var image: some View {
		ZStack(alignment: .bottomTrailing) {
			Image(book.genre.image)
				.resizable()
				.scaledToFit()

			Text(book.genre.rawValue)
				.fontWeight(.black)
				.foregroundStyle(.white)
				.padding(.horizontal, 10)
				.padding(.vertical, 5)
				.background(.ultraThinMaterial)
				.clipShape(.rect(cornerRadius: 10))
				.padding(5)
		}
	}

	@ViewBuilder
	private var bookDetails: some View {
		Text(book.author)
			.font(.title)
			.foregroundStyle(.secondary)

		Text("Прочтена \(book.readDate.formatted(date: .abbreviated, time: .shortened))")
			.font(.caption)

		Text(review)
			.italic(book.hasReview == false)
			.foregroundStyle(book.hasReview ? .primary : .secondary)
			.padding()

		RatingView(rating: .constant(book.rating))
			.font(.largeTitle)
	}

	// MARK: - Actions
	private func showDeleteAlert() {
		showingDeleteAlert.toggle()
	}

	private func deleteBook() {
		modelContext.delete(book)

		dismiss()
	}
}

// MARK: - Previews
#Preview(traits: .bookSample) {
	@Previewable @Query var books: [Book]

	NavigationStack {
		DetailView(book: books.first!)
	}
}
