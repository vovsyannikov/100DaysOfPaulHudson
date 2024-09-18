//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import SwiftUI

struct CheckoutView: View {
	@Bindable var order: Order

	@State private var responseMessage = ""
	@State private var showingConformation = false
	@State private var showingError = false

	// MARK: - Body
    var body: some View {
		ScrollView {
			VStack {
				AsyncImage(url: URL(string: "http://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
					image
						.resizable()
						.scaledToFit()
				} placeholder: {
					ProgressView()
				}
				.containerRelativeFrame(.vertical) { height, _ in
					height / 3
				}

				HStack(spacing: 0) {
					Text("Конечный итог: \(order.cost)")
					Text(Locale.current.localizedCurrencySymbol)
				}
				.font(.title)

				Button("Заказать") {
					Task {
						await placeOrder()
					}
				}
				.padding()
			}
		}
		.navigationTitle("Заказ")
		.navigationBarTitleDisplayMode(.inline)
		.scrollBounceBehavior(.basedOnSize)
		.alert("Спасибо за заказ!", isPresented: $showingConformation) {} message: {
			Text(responseMessage)
		}
		.alert("Что-то пошло не так", isPresented: $showingError) {} message: {
			Text(responseMessage)
		}
    }

	// MARK: - Actions
	private func placeOrder() async {
		guard let encodedData = try? JSONEncoder().encode(order)
		else {
			print("Failed to encode order")
			return
		}

		let url = URL(string: "https://reqres.in/api/cupcakes")!
		var request = URLRequest(url: url)
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "POST"

		do {
			let (responseData, _) = try await URLSession.shared.upload(for: request, from: encodedData)

			let decodedOrder = try JSONDecoder().decode(Order.self, from: responseData)
			responseMessage = "Ваш заказ на \(order.quantity) кекс(-ов) уже в пути"
			showingConformation.toggle()
		} catch {
			print("Check out failed: \(error.localizedDescription)")
			responseMessage = "Попробуйте ещё раз"
			showingError.toggle()
		}
	}
}

// MARK: - Preview
#Preview {
	NavigationStack {
		CheckoutView(order: Order())
	}
}
