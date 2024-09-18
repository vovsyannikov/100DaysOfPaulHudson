//
//  ContentView.swift
//  Instafilter
//
//  Created by Виталий Овсянников on 12.07.2024.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI

struct ContentView: View {
	@AppStorage("filterCount") private var filterCount = 0

	@Environment(\.requestReview) private var requestReview

	@State private var processedImage: Image?
	@State private var filterIntensity = 0.5
	@State private var selectedItem: PhotosPickerItem?

	@State private var storedImage: CIImage?

	@State private var currentFilter: CIFilter = CIFilter.circularWrap()

	@State private var showingFilters = false

	// MARK: - Props
	private let context = CIContext()
	private var noImageSelected: Bool {
		processedImage == nil
	}

	// MARK: - Body
    var body: some View {
		NavigationStack {
			VStack {
				Spacer()

				PhotosPicker(selection: $selectedItem) {
					mainView
				}
				.onChange(of: selectedItem, loadImage)

				Spacer()

				if let processedImage {
					filterIntensitySlider
						.onChange(of: filterIntensity, applyFilter)

					HStack {
						Button("Сменить фильтр", action: changeFilter)
							.disabled(noImageSelected)

						Spacer()


						ShareLink(item: processedImage, preview: SharePreview("Быстрофильтровання картинка", image: processedImage))
					}
				}
			}
			.padding([.horizontal, .bottom])
			.navigationTitle("Быстрофильтр")
			.confirmationDialog("Выберите фильтр", isPresented: $showingFilters) {
				Button("Кристализация") { setFilter(.crystallize()) }
				Button("Цветение") { setFilter(.bloom()) }
				Button("Гауссовое размытие") { setFilter(.gaussianBlur()) }
				Button("Пикселяция") { setFilter(.pixellate()) }
				Button("Сепия") { setFilter(.sepiaTone()) }
				Button("Маска размытия") { setFilter(.unsharpMask()) }
				Button("Виньетка") { setFilter(.vignette()) }

				Button("Отмена", role: .cancel) {  }
			}
		}
    }

	// MARK: - Subviews
	@ViewBuilder
	private var mainView: some View {
		if let processedImage {
			processedImage
				.resizable()
				.scaledToFit()
		} else {
			ContentUnavailableView("Не выбрано изображение", systemImage: "photo.badge.plus", description: Text("Нажмите для импорта"))
		}
	}

	private var filterIntensitySlider: some View {
		HStack {
			Text("Сила")
			Slider(value: $filterIntensity)
		}
	}

	// MARK: - Actions
	private func loadImage() {
		Task {
			guard let imageData = try await selectedItem?.loadTransferable(type: Data.self),
				  let inputImage = UIImage(data: imageData)
			else { return }

			storedImage = CIImage(image: inputImage)

			setInputImage()
			applyFilter()
		}
	}

	private func applyFilter() {
		let inputKeys = currentFilter.inputKeys

		if inputKeys.contains(kCIInputIntensityKey) {
			currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
		}
		if inputKeys.contains(kCIInputRadiusKey) {
			currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey)
		}
		if inputKeys.contains(kCIInputScaleKey) {
			currentFilter.setValue(filterIntensity * 100, forKey: kCIInputScaleKey)
		}
		if inputKeys.contains(kCIInputAmountKey) {
			currentFilter.setValue(filterIntensity, forKey: kCIInputAmountKey)
		}

		guard let outputImage = currentFilter.outputImage,
			  let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
		else { return }

		let uiImage = UIImage(cgImage: cgImage)

		processedImage = Image(uiImage: uiImage)
	}

	private func changeFilter() {
		showingFilters = true
	}

	@MainActor
	private func setFilter(_ filter: CIFilter) {
		currentFilter = filter
		setInputImage()

		filterCount += 1

		if filterCount == 20 {
			requestReview()
		}
	}

	private func setInputImage() {
		currentFilter.setValue(storedImage, forKey: kCIInputImageKey)
		applyFilter()
	}
}

// MARK: - Previews
#Preview {
    ContentView()
}
