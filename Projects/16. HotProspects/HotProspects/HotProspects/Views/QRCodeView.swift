//
//  QRCodeView.swift
//  HotProspects
//
//  Created by Виталий Овсянников on 16.07.2024.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

struct QRCodeView: View {
	// MARK: - Private props
	private let name: String
	private let emailAddress: String

	private let context = CIContext()
	private let filter = CIFilter.qrCodeGenerator()
	private var qrCode: UIImage {
		generateQRCode()
	}

	// MARK: - Initializers
	init(from prospect: Prospect) {
		self.name = prospect.name
		self.emailAddress = prospect.emailAddress
	}

	init(name: String, emailAddress: String) {
		self.name = name
		self.emailAddress = emailAddress
	}

	// MARK: - Body
    var body: some View {
		Image(uiImage: qrCode)
			.interpolation(.none)
			.resizable()
			.scaledToFit()
			.frame(width: 200, height: 200)
			.frame(maxWidth: .infinity)
			.contextMenu {
				let image = Image(uiImage: qrCode)
				ShareLink(item: image, preview: SharePreview("Код \(name)", image: image))
			}
    }

	// MARK: - Actions
	private func generateQRCode() -> UIImage {
		let string = Prospect.generateCode(name: name, emailAddress: emailAddress)
		filter.message = Data(string.utf8)

		guard let outputImage = filter.outputImage,
			  let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
		else { return UIImage(systemName: "xmark.circle") ?? UIImage() }

		return UIImage(cgImage: cgImage)
	}
}

// MARK: - Previews
#Preview {
	QRCodeView(from: .example)
}
