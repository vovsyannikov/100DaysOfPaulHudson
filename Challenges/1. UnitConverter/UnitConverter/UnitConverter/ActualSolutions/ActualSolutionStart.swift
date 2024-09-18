//
//  ActualSolutionStart.swift
//  UnitConverter
//
//  Created by Виталий Овсянников on 03.07.2024.
//

import SwiftUI

struct ActualSolutionStart: View {
	var body: some View {
		NavigationStack {
			Form {
				Section("Выберите конвертер") {
					NavigationLink("Температуры", value: Converter.temperature)
					NavigationLink("Расстояния", value: Converter.distance)
					NavigationLink("Время", value: Converter.time)
					NavigationLink("Объём", value: Converter.volume)
				}
			}
			.navigationTitle("Верное решение")
			.navigationDestination(for: Converter.self) { converter in
				switch converter {
					case .temperature: TemperatureSolution()
					case .distance: DistanceSolution()
					case .time: TimeSolution()
					case .volume: VolumeSolution()
				}
			}
		}
	}
}

#Preview {
    ActualSolutionStart()
}
