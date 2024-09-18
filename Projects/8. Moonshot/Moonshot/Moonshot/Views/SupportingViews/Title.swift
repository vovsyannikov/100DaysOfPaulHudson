//
//  Title.swift
//  Moonshot
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import SwiftUI

struct Title: View {
	let text: String

	init(_ text: String) {
		self.text = text
	}

    var body: some View {
		Text(text)
			.font(.title.bold())
			.padding(.bottom, 5)
    }
}

#Preview {
    Title("Hello, World!")
}
