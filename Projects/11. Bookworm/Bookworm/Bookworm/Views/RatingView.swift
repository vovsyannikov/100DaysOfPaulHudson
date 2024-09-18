//
//  RatingView.swift
//  Bookworm
//
//  Created by Виталий Овсянников on 12.07.2024.
//

import SwiftUI

struct RatingView: View {
	@Binding var rating: Int

	// MARK: - Props
	var label = ""
	var maximumRating = 5

	var offImage: Image?
	var onImage = Image(systemName: "star.fill")

	var offColor = Color.gray
	var onColor = Color.yellow

	// MARK: - Body
    var body: some View {
		HStack {
			if label.isEmpty == false {
				Text(label)
				Spacer()
			}

			ForEach(1..<maximumRating + 1, id: \.self) { number in
				Button {
					rating = number
				} label: {
					image(for: number)
						.foregroundStyle(number > rating ? offColor : onColor)
				}
			}
		}
		.buttonStyle(.plain)
    }

	// MARK: - Subviews
	private func image(for number: Int) -> Image {
		number > rating ? (offImage ?? onImage) : onImage
	}
}

// MARK: - Previews
#Preview(traits: .sizeThatFitsLayout) {
	@Previewable @State var rating = 3
	
	RatingView(rating: $rating)
}
