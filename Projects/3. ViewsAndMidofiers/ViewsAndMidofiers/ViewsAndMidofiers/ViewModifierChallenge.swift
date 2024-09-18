//
//  ViewModifierChallenge.swift
//  ViewsAndModifiers
//
//  Created by Виталий Овсянников on 06.07.2024.
//

import SwiftUI

struct BigTitle: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.largeTitle.weight(.semibold))
			.foregroundStyle(.blue)
	}
}

extension View {
	func bigTitle() -> some View {
		modifier(BigTitle())
	}
}

struct ViewModifierChallenge: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
			.bigTitle()
    }
}

#Preview {
    ViewModifierChallenge()
}
