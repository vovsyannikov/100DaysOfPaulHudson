//
//  Locale+ext.swift
//  iExpense
//
//  Created by Виталий Овсянников on 11.07.2024.
//

import Foundation

extension Locale {
	var localizedCurrencySymbol: String {
		if identifier.localizedStandardContains("RU") {
			return "₽"
		}

		return currencySymbol ?? "$"
	}
}
