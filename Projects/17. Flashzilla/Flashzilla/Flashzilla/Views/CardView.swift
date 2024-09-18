//
//  CardView.swift
//  Flashzilla
//
//  Created by Виталий Овсянников on 16.07.2024.
//

import SwiftUI

struct CardView: View {
	// MARK: State
	@Environment(\.accessibilityDifferentiateWithoutColor) private var withoutColor
	@Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled

	@State private var isShowingAnswer = false
	@State private var offset = CGSize.zero
	@State private var isDragging = false

	// MARK: - Props
	let card: Card
	var removal: ((Double) -> Void)? = nil

	private var mainOffset: Double {
		offset.width / 50.0
	}
	private var offsetOpacity: Double {
		2 - abs(mainOffset)
	}

	// MARK: - Body
    var body: some View {
		ZStack {
			cardBackground

			VStack(spacing: 15) {
				if voiceOverEnabled {
					voiceOverContent
				} else {
					normalContent
				}
			}
			.padding(20)
			.multilineTextAlignment(.center)
		}
		.frame(width: 450, height: 250)
		.rotationEffect(.degrees(offset.width / 5.0))
		.offset(x: offset.width * 3.0)
		.opacity(offsetOpacity)
		.animation(.bouncy, value: offset)
		.accessibilityAddTraits([.isButton])
		.gesture(
			DragGesture()
				.onChanged { drag in
					offset = drag.translation
					isDragging = true
				}
				.onEnded { drag in
					isDragging = false

					if abs(offset.width) > 100 {
						removal?(offset.width)
					} else {
						offset = .zero
					}
				}
		)
		.onTapGesture {
			withAnimation {
				isShowingAnswer.toggle()
			}
		}
    }

	// MARK: - Subviews
	private var cardShape: some Shape {
		RoundedRectangle(cornerRadius: 25)
	}

	private var cardBackground: some View {
		cardShape
			.fill(
				withoutColor
				? .white
				: .white.opacity(1 - abs(mainOffset))
			)
			.background(
				withoutColor || !isDragging
				? nil
				: cardShape
					.fill(offset.width > 0 ? .green : .red)
			)
			.shadow(radius: 10)
	}

	private var voiceOverContent: some View {
		Text(isShowingAnswer ? card.answer : card.prompt)
	}

	@ViewBuilder
	private var normalContent: some View {
		Text(card.prompt)
			.font(.largeTitle)
			.foregroundStyle(.black)

		if isShowingAnswer {
			Text(card.answer)
				.font(.title)
				.foregroundStyle(.secondary)
				.transition(.scale(0, anchor: .bottom))
		}
	}

	// MARK: - Actions
	func onRemove(remove: @escaping (Double) -> Void) -> CardView {
		CardView(card: card, removal: remove)
	}
}

// MARK: - Previews
#Preview {
	CardView(card: .example)
}
