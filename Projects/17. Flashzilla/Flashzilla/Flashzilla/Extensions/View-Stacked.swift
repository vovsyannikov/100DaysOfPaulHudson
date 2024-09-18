//
//  View-Stacked.swift
//  Flashzilla
//
//  Created by Виталий Овсянников on 16.07.2024.
//

import SwiftUI

extension View {
	func stacked(at position: Int, in total: Int) -> some View {
		let offset = Double(total - position)

		return self.offset(y: offset * 10)
	}
}
