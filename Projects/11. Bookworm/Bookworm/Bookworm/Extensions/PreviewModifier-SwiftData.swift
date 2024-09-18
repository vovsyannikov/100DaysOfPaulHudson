//
//  PreviewModifier-SwiftData.swift
//  Bookworm
//
//  Created by Виталий Овсянников on 12.07.2024.
//

import Foundation
import SwiftData
import SwiftUI

class BookSample: PreviewModifier {
	typealias Context = ModelContainer

	static func makeSharedContext() async throws -> Context {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: Book.self, configurations: config)

		Book.createSampleData(in: container)

		return container
	}

	func body(content: Content, context: Context) -> some View {
		content.modelContainer(context)
	}
}

extension PreviewTrait where T == Preview.ViewTraits {
	@MainActor static var bookSample: Self = .modifier(BookSample())
}
