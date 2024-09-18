//
//  ContentView.swift
//  BucketList
//
//  Created by Виталий Овсянников on 13.07.2024.
//

import MapKit
import SwiftUI

struct ContentView: View {
	// MARK: State
	@State private var viewModel = ViewModel()

	@State private var mapStyle = MapStyle.hybrid
	@State private var currentPosition = MapCameraPosition.region(
		MKCoordinateRegion(
			center: .init(latitude: 55.753998,
						  longitude: 37.620532),
			span: .init(latitudeDelta: 8,
						longitudeDelta: 8))
	)

	// MARK: - Body
	var body: some View {
		if viewModel.isUnlocked {
			mainView
		} else {
			unauthorizedView
		}
	}

	// MARK: - Subviews
	private var unauthorizedView: some View {
		Button("Разблокировать", action: viewModel.authenticate)
			.buttonStyle(.borderedProminent)
			.alert("Не удалось войти с помощью биометрии", isPresented: $viewModel.showErrorMessage) {} message: {
				Text(viewModel.error?.errorDescription ?? "")
			}

	}

	private var mainView: some View {
		ZStack(alignment: .bottom) {
			MapReader { mapProxy in
				Map(position: $currentPosition) {
					ForEach(viewModel.locations) { location in
						Annotation(location.name, coordinate: location.coordinates) {
							Image(systemName: "star.circle")
								.resizable()
								.foregroundStyle(.red)
								.frame(width: 44, height: 44)
								.background(.ultraThinMaterial)
								.clipShape(.circle)
								.onLongPressGesture {
									viewModel.selectedLocation = location
								}
						}
					}
				}
				.mapStyle(mapStyle.style)
				.onTapGesture { position in
					guard let coordinates = mapProxy.convert(position, from: .local) else { return }
					viewModel.addLocation(at: coordinates)
				}

				HStack {
					Menu("Опции", systemImage: "ellipsis.circle") {
						Picker("Стиль карты", selection: $mapStyle) {
							ForEach(MapStyle.allCases) {
								Text($0.rawValue)
									.tag($0)
							}
						}
					}
				}
			}
			.sheet(item: $viewModel.selectedLocation) { location in
				EditView(for: location, onSave: viewModel.update)
			}
		}
	}
}

// MARK: - MapStyle
extension ContentView {
	enum MapStyle: String, CaseIterable, Identifiable {
		var id: Self { self }

		case standard = "Схема"
		case imagery = "Спутник"
		case hybrid = "Гибрид"

		var style: MapKit.MapStyle {
			switch self {
				case .standard: .standard
				case .imagery: .imagery
				case .hybrid: .hybrid
			}
		}
	}
}

// MARK: - Preview
#Preview {
    ContentView()
}
