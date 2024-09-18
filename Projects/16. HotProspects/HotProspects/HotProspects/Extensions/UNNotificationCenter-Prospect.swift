//
//  UNNotificationCenter-Prospect.swift
//  HotProspects
//
//  Created by Виталий Овсянников on 16.07.2024.
//

import UserNotifications

extension UNUserNotificationCenter {
	func addNotification(for prospect: Prospect) {
		let addRequest = {
			let content = UNMutableNotificationContent()
			content.title = "Свяжитесь с \(prospect.name)"
			content.subtitle = prospect.emailAddress
			content.sound = .default

#if DEBUG
			let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
#else
			var dateComponents = DateComponents()
			dateComponents.hour = 9

			let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
#endif

			let request = UNNotificationRequest(identifier: UUID().uuidString,
												content: content,
												trigger: trigger)

			self.add(request)
		}

		self.getNotificationSettings { settings in
			Task {
				if settings.authorizationStatus == .authorized {
					addRequest()
				} else {
					do {
						if try await self.requestAuthorization(options: [.alert, .badge, .sound]) {
							addRequest()
						}
					} catch {
						print(error.localizedDescription)
					}
				}
			}
		}
	}
}
