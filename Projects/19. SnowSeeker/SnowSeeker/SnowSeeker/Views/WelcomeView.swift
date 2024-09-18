//
//  WelcomeView.swift
//  SnowSeeker
//
//  Created by Виталий Овсянников on 18.07.2024.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        Text("Welcome to SnowSeeker!")
			.font(.largeTitle)

		Text("Please select a resort from left-hand side menu; Swipe from the edge to show it")
			.foregroundStyle(.secondary)
    }
}

#Preview {
    WelcomeView()
}
