//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import SwiftUI

struct AddressView: View {
	@Bindable var order: Order

	// MARK: - Body
    var body: some View {
		Form {
			Section {
				TextField("Имя", text: $order.name)
				TextField("Город", text: $order.city)
				TextField("Адрес", text: $order.streetAddress)
			}

			Section {
				NavigationLink("Оплатить") {
					CheckoutView(order: order)
				}
			}
			.disabled(order.hasValidAddress == false)
		}
		.navigationTitle("Детали доставки")
		.navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
#Preview {
	NavigationStack {
		AddressView(order: Order())
	}
}
