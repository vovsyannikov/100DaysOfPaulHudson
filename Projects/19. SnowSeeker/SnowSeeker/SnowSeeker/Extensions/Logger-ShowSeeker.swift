//
//  Logger-ShowSeeker.swift
//  SnowSeeker
//
//  Created by Виталий Овсянников on 18.07.2024.
//

import Foundation
import OSLog

extension Logger {
	static let subsystem = Bundle.main.bundleIdentifier!

	static let ui = Logger(subsystem: subsystem, category: "UI")
	static let data = Logger(subsystem: subsystem, category: "Data")
}
