//
//  SkiDetailsView.swift
//  SnowSeeker
//
//  Created by Виталий Овсянников on 18.07.2024.
//

import SwiftUI

struct SkiDetailsView: View {
	let resort: Resort
	
    var body: some View {
		Group {
			DetailsView("Elevation", value: resort.elevationDescription)
			DetailsView("Snow Level", value: resort.snowDepthDescription)
		}
		.frame(maxWidth: .infinity)
    }
}

#Preview {
	SkiDetailsView(resort: .example)
}
