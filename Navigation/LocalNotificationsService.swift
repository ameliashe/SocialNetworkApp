//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Amelia Romanova on 4/19/25.
//

import Foundation
import UserNotifications
import UIKit

enum LocalNotificationIdentifier: String {
	case latestUpdates = "latestUpdates"
}

class LocalNotificationsService: NSObject, UNUserNotificationCenterDelegate {

	static let shared = LocalNotificationsService()

	private override init() {
		super.init()
		center.delegate = self
	}

	let center = UNUserNotificationCenter.current()

	func registerForLatestUpdatesIfPossible() {
		registerUpdatesCategory()
		Task {
			try await center.requestAuthorization(options: [.alert, .badge, .sound])
			guard await checkPermissionsStatus() else {
				return
			}

			let nextNotification = await center.pendingNotificationRequests()
			if nextNotification.contains(where: { $0.identifier == LocalNotificationIdentifier.latestUpdates.rawValue}) {
				return
			}

			var date = DateComponents()
			date.hour = 19
			date.minute = 00

			addNotification(date: date)
		}

	}

	func checkPermissionsStatus() async -> Bool {
		await UNUserNotificationCenter.current().notificationSettings().authorizationStatus == .authorized
	}

	func addNotification(date: DateComponents) {

		let content = UNMutableNotificationContent()
		content.title = NSLocalizedString("Check the latest updates!", comment: "Notification title")
		content.body = NSLocalizedString("Open this update to see what's new", comment: "Notification body")
		content.sound = .default
		content.categoryIdentifier = categoryID

		let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

		let request = UNNotificationRequest(identifier: LocalNotificationIdentifier.latestUpdates.rawValue, content: content, trigger: trigger)
		UNUserNotificationCenter.current().add(request)
	}

	private var categoryID = "updates"
	static var actionID = "latestPost"
	func registerUpdatesCategory() {
		let action = UNNotificationAction(identifier: Self.actionID, title: NSLocalizedString("View latest post", comment: "Notification action"), options: [.foreground])

		let category = UNNotificationCategory(identifier: categoryID, actions: [action], intentIdentifiers: [])

		UNUserNotificationCenter.current().setNotificationCategories([category])
	}

	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
		if response.actionIdentifier == Self.actionID {
			let alert = await UIAlertController(title: NSLocalizedString("You've clicked the action!", comment: "Action alert title"), message: NSLocalizedString("No new posts yet...", comment: "Action alert message"), preferredStyle: .alert)
			await MainActor.run {
				if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
					let rootVC = windowScene.windows.first(where: {$0.isKeyWindow })?.rootViewController
						rootVC?.present(alert, animated: true)

				}
			}
		}
	}
}



