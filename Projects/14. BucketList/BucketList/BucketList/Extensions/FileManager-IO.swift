//
//  FileManager-IO.swift
//  BucketList
//
//  Created by Виталий Овсянников on 15.07.2024.
//

import Foundation

extension FileManager {
	func write(_ data: Data, filename: String? = nil, extension fileExtension: String? = nil, to url: URL) throws {
		var destination = url
		if var filename = filename {

			if let fileExtension {
				filename += ".\(fileExtension)"
			}

			destination.append(path: filename)
		}

		try data.write(to: destination, options: [.atomic, .completeFileProtection])
	}

	func string(from url: URL) throws -> String {
		try String(contentsOf: url)
	}
}
