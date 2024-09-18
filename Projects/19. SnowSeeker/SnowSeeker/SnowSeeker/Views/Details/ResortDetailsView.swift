//
//  ResortDetailsView.swift
//  SnowSeeker
//
//  Created by Виталий Овсянников on 18.07.2024.
//

import SwiftUI

struct ResortDetailsView: View {
	let resort: Resort

    var body: some View {
		Group {
			DetailsView("Size", value: resort.size.description)
			DetailsView("Price", value: resort.price.description)
		}
		.frame(maxWidth: .infinity)
    }
}

#Preview {
	ResortDetailsView(resort: .example)
}
