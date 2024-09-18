//
//  MeView.swift
//  HotProspects
//
//  Created by Виталий Овсянников on 16.07.2024.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
	// MARK: State
	@AppStorage("name") private var name = "Аноним"
	@AppStorage("emailAddress") private var emailAddress = "you@yoursite.com"

	// MARK: - Body
    var body: some View {
		NavigationStack {
			Form {
				TextField("Ваше имя", text: $name)
					.textContentType(.name)
					.font(.title)

				TextField("Ваш электронный адрес", text: $emailAddress)
					.textContentType(.emailAddress)
					.textInputAutocapitalization(.never)
					.font(.title)

				QRCodeView(name: name, emailAddress: emailAddress)
			}
			.navigationTitle("Ваш код")
		}
    }
}

// MARK: - Previews
#Preview {
    MeView()
}
