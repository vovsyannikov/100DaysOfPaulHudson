//
//  ContentView.swift
//  Bookworm
//
//  Created by Виталий Овсянников on 12.07.2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	@Query(sort: [
		SortDescriptor(\Book.title),
		SortDescriptor(\Book.author)
	])
	private var books: [Book]

	@State private var showingAddScreen = false

	// MARK: - Body
	var body: some View {
		NavigationStack {
			List {
				ForEach(books, content: bookView)
					.onDelete(perform: deleteBooks)
			}
			.navigationTitle("Книжный червь")
			.navigationDestination(for: Book.self, destination: DetailView.init)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Добавить книгу", systemImage: "plus", action: addBook)
				}

				ToolbarItem(placement: .topBarLeading) {
					EditButton()
				}
			}
			.sheet(isPresented: $showingAddScreen) { AddBookView() }
		}
	}

	// MARK: - Subviews
	private func bookView(for book: Book) -> some View {
		NavigationLink(value: book) {
			HStack {
				EmojiRatingView(rating: book.rating)
					.font(.largeTitle)

				VStack(alignment: .leading) {
					Text(book.title)
						.font(.headline)
						.italic(!book.hasTitle)
						.foregroundStyle(book.rating < 2 ? .red : .primary)

					Text(book.author)
						.foregroundStyle(.secondary)
						.italic(!book.hasAuthor)
				}
			}
		}
	}

	// MARK: - Actions
	private func addBook() {
		showingAddScreen.toggle()
	}

	private func deleteBooks(at offsets: IndexSet) {
		for offset in offsets {
			let book = books[offset]

			modelContext.delete(book)
		}
	}
}

// MARK: - Previews
#Preview("iPhone", traits: .bookSample) {
    ContentView()
}
