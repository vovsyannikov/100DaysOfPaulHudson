//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Виталий Овсянников on 16.07.2024.
//

import CodeScanner
import SwiftData
import SwiftUI
import UserNotifications

struct ProspectsView: View {
	// MARK: State
	@Environment(\.editMode) var editMode
	@Environment(\.modelContext) var modelContext

	@State private var isScanning = false
	@State private var sortType = Prospect.SortType.byName

	// MARK: - Props
	let filter: Prospect.FilterType

	// MARK: - Body
    var body: some View {
		NavigationStack {
			ProspectsListView(filter: filter, sortOrder: sortType.descriptors)
				.navigationTitle(filter.title)
				.toolbar {
					ToolbarItem {
						Button("Сканировать", systemImage: "qrcode.viewfinder") {
							isScanning = true
						}
					}

					ToolbarItemGroup(placement: .topBarLeading) {
						EditButton()

						Menu {
							Picker("Вид", selection: $sortType) {
								ForEach(Prospect.SortType.allCases) { sort in
									Label(sort.label.title, systemImage: sort.label.image)
										.tag(sort)
								}
							}
						} label: {
							Label("Вид", systemImage: "arrow.up.arrow.down")
						}
					}
				}
				.sheet(isPresented: $isScanning) {
					CodeScannerView(codeTypes: [.qr],
									simulatedData: Prospect.example.codeString,
									completion: handleScan)
				}
		}
    }

	// MARK: - Actions
	private func handleScan(result: Result<ScanResult, ScanError>) {
		isScanning = false

		switch result {
			case .success(let scanResult):
				let details = scanResult.string.components(separatedBy: "\n")
				guard details.count == 2 else { return }

				let newPerson = Prospect(name: details[0], emailAddress: details[1])

				modelContext.insert(newPerson)

			case .failure(let error):
				print("Scanning error: \(error.localizedDescription)")
		}
	}
}

// MARK: - Previews
#Preview {
	ProspectsView(filter: .all)
		.modelContainer(Prospect.container)
}
