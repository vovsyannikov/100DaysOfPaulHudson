//
//  Bundle-Decodable.swift
//  SnowSeeker
//
//  Created by Виталий Овсянников on 18.07.2024.
//

import Foundation
import OSLog

extension Bundle {
	func decode<T: Decodable>(_ filename: String) -> T {
		Logger.data.debug("Fetching URL for '\(filename)'")
		guard let fileURL = url(forResource: filename, withExtension: nil)
		else {
			Logger.data.critical("File '\(filename)' not found")
			fatalError()
		}

		defer {
			Logger.data.info("Success fetching data from '\(filename)'")
		}

		do {
			Logger.data.debug("Fetching data from '\(filename)'")
			let data = try Data(contentsOf: fileURL)

			let decoder = JSONDecoder()

			return try decoder.decode(T.self, from: data)
		} catch DecodingError.keyNotFound(_, let context) {
			Logger.data.critical("Failed to decode '\(filename)' due to missing key - \(context.debugDescription)")
		} catch DecodingError.valueNotFound(_, let context) {
			Logger.data.critical("Failed to decode '\(filename)' due to missing value - \(context.debugDescription)")
		} catch DecodingError.typeMismatch(_, let context) {
			Logger.data.critical("Failed to decode '\(filename)' due to type mismatch - \(context.debugDescription)")
		} catch DecodingError.dataCorrupted(_) {
			Logger.data.critical("Failed to decode '\(filename)' due to data corruption")
		} catch {
			Logger.data.critical("Failed to decode '\(filename)': \(error.localizedDescription)")
		}
		
		fatalError()
	}
}
