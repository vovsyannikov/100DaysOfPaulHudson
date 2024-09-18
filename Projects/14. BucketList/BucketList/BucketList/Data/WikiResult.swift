//
//  WikiResult.swift
//  BucketList
//
//  Created by Виталий Овсянников on 15.07.2024.
//

import Foundation

struct WikiResult: Codable {
	static func url(for location: Location) -> URL? {
		var urlComponents = URLComponents()
		urlComponents.scheme = "https"
		urlComponents.host = "ru.wikipedia.org"
		urlComponents.path = "/w/api.php"

		urlComponents.queryItems = [
			.init(name: "ggscoord", value: "\(location.latitude)|\(location.longitude)"),
			.init(name: "action", value: "query"),
			.init(name: "prop", value: "coordinates|pageimages|pageterms"),
			.init(name: "colimit", value: "50"),
			.init(name: "piprop", value: "thumbnail"),
			.init(name: "pithumbsize", value: "500"),
			.init(name: "pilimit", value: "50"),
			.init(name: "wbptterms", value: "description"),
			.init(name: "generator", value: "geosearch"),
			.init(name: "ggsradius", value: "10000"),
			.init(name: "ggslimit", value: "50"),
			.init(name: "format", value: "json")
		]

		return urlComponents.url
	}

	let query: Query
}

extension WikiResult {
	struct Query: Codable {
		let pages: [Int: Page]
	}
}

extension WikiResult.Query {
	struct Page: Codable, Comparable {
		let pageid: Int
		let title: String
		let terms: [String: [String]]?

		var description: String {
			terms?["description"]?.first ?? "Нет описания"
		}

		static func < (lhs: WikiResult.Query.Page, rhs: WikiResult.Query.Page) -> Bool {
			lhs.title < rhs.title
		}
	}
}
