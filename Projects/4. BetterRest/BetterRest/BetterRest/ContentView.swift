//
//  ContentView.swift
//  BetterRest
//
//  Created by Виталий Овсянников on 07.07.2024.
//

import CoreML
import SwiftUI

struct ContentView: View {
	@State private var wakeUp = Self.defaultWakeTime
	@State private var sleepAmount = 8.0
	@State private var coffeeAmount = 1
	@State private var estimatedSleep = ""

	@State private var alertTitle = ""
	@State private var alertMessage = ""
	@State private var showingAlert = false

	@State private var look = Look.challenge

	private static var defaultWakeTime: Date {
		var components = DateComponents()

		components.hour = 7
		components.minute = 0

		return Calendar.current.date(from: components) ?? .now
	}

	// MARK: - Body
	var body: some View {
		NavigationStack {
			Group {
				switch look {
				case .draft:
					draftLook

				case .base:
					baseLook

				case .challenge:
					challengeLook
				}
			}
			.navigationTitle("Отдохни")
			.toolbar {
				if look != .challenge {
					ToolbarItem {
						Button("Вычислить", action: calculateBedtime)
					}
				}

				ToolbarItem(placement: .topBarLeading) {
					Menu {
						Picker("Вид", selection: $look) {
							ForEach(Look.allCases) { look in
								Text(look.rawValue)
									.tag(look)
							}
						}
					} label: {
						Label("Вид", systemImage: "square.stack")
					}
				}
			}
		}
		.alert(alertTitle, isPresented: $showingAlert) {
			Button("OK") { }
		} message: {
			Text(alertMessage)
		}
	}

	// MARK: - Views
	private var draftLook: some View {
		VStack {
			Text("Когда вы хотите проснуться?")
				.font(.headline)

			DatePicker("Выберите время",
					   selection: $wakeUp,
					   displayedComponents: .hourAndMinute)
			.labelsHidden()

			Text("Сколько желаете поспать?")
				.font(.headline)

			Stepper("\(sleepAmount.formatted()) ч.",
					value: $sleepAmount,
					in: 4...12, step: 0.25)

			Text("Сколько кофе вы пьёте в день")
				.font(.headline)

			Stepper("Количество кружек: \(coffeeAmount)",
					value: $coffeeAmount,
					in: 1...20)
		}
	}

	private var baseLook: some View {
		Form {
			VStack(alignment: .leading, spacing: 0) {
				Text("Когда вы хотите проснуться?")
					.font(.headline)

				DatePicker(
					"Выберите время",
					selection: $wakeUp,
					displayedComponents: .hourAndMinute
				)
				.labelsHidden()
			}

			VStack(alignment: .leading, spacing: 0)  {
				Text("Сколько желаете поспать?")
					.font(.headline)

				Stepper(
					"\(sleepAmount.formatted()) ч.",
					value: $sleepAmount,
					in: 4...12, step: 0.25
				)
			}

			VStack(alignment: .leading, spacing: 0) {
				Text("Сколько кофе вы пьёте в день?")
					.font(.headline)

				Stepper(
					"Кружек: \(coffeeAmount)",
					value: $coffeeAmount,
					in: 1...20
				)
			}
		}
	}

	private var challengeLook: some View {
		ChallengeLook(
			wakeUp: $wakeUp,
			sleepAmount: $sleepAmount,
			coffeeAmount: $coffeeAmount,
			estimatedSleep: calculateEstimatedSleep()
		)
	}

	// MARK: - Actions
	private func calculateBedtime() {
		do {
			let config = MLModelConfiguration()
			let model = try SleepCalculator(configuration: config)

			let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
			let hour = components.hour ?? 0
			let minute = components.minute ?? 0
			let seconds = (hour * 60 * 60) + (minute * 60)

			let prediction = try model.prediction(wake: Int64(seconds),
												  estimatedSleep: sleepAmount,
												  coffee: Int64(coffeeAmount))

			let sleepTime = wakeUp - prediction.actualSleep

			alertTitle = "Ваше идеальное время отхода ко сну…"
			alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
		} catch {
			alertTitle = "Ошибка"
			alertMessage = "Что-то пошло не так при вычислении времени отхода ко сну"
		}

		showingAlert = true
	}

	private func calculateEstimatedSleep() -> String {
		do {
			let config = MLModelConfiguration()
			let model = try SleepCalculator(configuration: config)

			let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
			let hour = components.hour ?? 0
			let minute = components.minute ?? 0
			let seconds = (hour * 60 * 60) + (minute * 60)

			let prediction = try model.prediction(wake: Int64(seconds),
												  estimatedSleep: sleepAmount,
												  coffee: Int64(coffeeAmount))

			let sleepTime = wakeUp - prediction.actualSleep


			return sleepTime.formatted(date: .omitted, time: .shortened)
		} catch {
			return ""
		}
	}
}

// MARK: - Look
extension ContentView {
	enum Look: String, Identifiable, CaseIterable {
		case draft = "Черновой"
		case base = "Базовый"
		case challenge = "Задание"

		var id: String { rawValue }
	}
}

// MARK: - ChallengeLook
struct ChallengeLook: View {
	@Binding var wakeUp: Date
	@Binding var sleepAmount: Double
	@Binding var coffeeAmount: Int

	let estimatedSleep: String

	var body: some View {
		VStack {
			Form {
				Section("Когда вы хотите проснуться?") {
					DatePicker(
						"Выберите время",
						selection: $wakeUp,
						displayedComponents: .hourAndMinute
					)
					.labelsHidden()
				}

				Section("Сколько желаете поспать?") {
					Stepper(
						"\(sleepAmount.formatted()) ч.",
						value: $sleepAmount,
						in: 4...12, step: 0.25
					)
				}

				Section("Сколько кофе вы пьёте в день?") {
					Picker("Кружек", selection: $coffeeAmount) {
						ForEach(1...20, id: \.self) {
							Text($0, format: .number)
						}
					}
				}
			}
			Text("Время отхода ко сну:")

			Text(estimatedSleep)
				.font(.largeTitle.bold())
		}
	}
}

// MARK: - Preview
#Preview {
	ContentView()
}
