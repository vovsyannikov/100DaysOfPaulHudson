//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import SwiftUI

struct ContentView: View {
	@State private var order = Order()

	// MARK: - Body
    var body: some View {
		NavigationStack {
			Form {
				Section {
					Picker("Тип кексов", selection: $order.type) {
						ForEach(Order.CupcakeType.allCases) { type in
							Text(type.description)
								.tag(type)
						}
					}

					Stepper("Количество: \(order.quantity)", value: $order.quantity, in: 3...20)
				}

				Section {
					Toggle("Что-нибудь добавить?", isOn: $order.specialRequestsEnabled)

					if order.specialRequestsEnabled {
						Toggle("Дополнительная глазурь", isOn: $order.extraFrosting)
						Toggle("Добавить посыпку", isOn: $order.addSprinkles)
					}
				}

				Section {
					NavigationLink("Детали доставки") {
						AddressView(order: order)
					}
				}
			}
			.navigationTitle("КЕКсовая")
		}
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
