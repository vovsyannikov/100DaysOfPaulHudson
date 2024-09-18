//
//  DetailsView.swift
//  SnowSeeker
//
//  Created by Виталий Овсянников on 18.07.2024.
//

import SwiftUI

struct DetailsView: View {
	let description: String
	let value: String

	init(_ description: String, value: String) {
		self.description = description
		self.value = value
	}

	var body: some View {
		VStack {
			Text(description)
				.font(.caption.bold())

			Text(value)
			.font(.title3)
		}
	}
}

#Preview {
	let resort = Resort.example

	return Group {
		DetailsView("Elevation", value: resort.elevationDescription)
		DetailsView("Snow Level", value: resort.snowDepthDescription)
		DetailsView("Size", value: resort.size.description)
		DetailsView("Price", value: resort.price.description)
	}
}
