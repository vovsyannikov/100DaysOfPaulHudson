//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import Foundation

extension Bundle {
	func decode<T: Decodable>(_ file: String) -> T {
		guard let url = self.url(forResource: file, withExtension: nil)
		else { fatalError("Failed to locate \(file) in bundle") }

		let errorMessage = "Failed to decode \(file) from bundle"
		do {
			let data = try Data(contentsOf: url)
			let decoder = JSONDecoder()

			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd"
			
			decoder.dateDecodingStrategy = .formatted(dateFormatter)

			let decodedValue = try decoder.decode(T.self, from: data)

			return decodedValue
		} catch DecodingError.typeMismatch(_, let context) {
			fatalError(errorMessage + " due to type mismatch – \(context.debugDescription)")
		} catch DecodingError.keyNotFound(let key, let context) {
			fatalError(errorMessage + " due to missing key '\(key.stringValue)' — \(context.debugDescription)")
		} catch DecodingError.valueNotFound(let type, let context) {
			fatalError(errorMessage + " due to missing \(type) value – \(context.debugDescription)")
		} catch DecodingError.dataCorrupted(_) {
			fatalError(errorMessage + " because of invalid JSON")
		} catch {
			fatalError(errorMessage + ": \(error.localizedDescription)")
		}
	}
}
