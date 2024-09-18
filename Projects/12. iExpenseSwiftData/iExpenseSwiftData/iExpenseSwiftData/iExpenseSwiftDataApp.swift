//
//  iExpenseSwiftDataApp.swift
//  iExpenseSwiftData
//
//  Created by Виталий Овсянников on 12.07.2024.
//

import SwiftData
import SwiftUI

@main
struct iExpenseSwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
		.modelContainer(for: ExpenseItem.self)
    }
}
