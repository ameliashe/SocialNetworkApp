//
//  AppDelegate.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 10/13/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		FirebaseApp.configure()
		
		let db = Firestore.firestore()
		var settings = db.settings
		let cacheSettings = PersistentCacheSettings(sizeBytes: (20 * 1024 * 1024) as NSNumber)
		settings.cacheSettings = cacheSettings
		db.settings = settings
		
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		do {
			try Auth.auth().signOut()
		} catch {
			print("Couldn't sign out")
		}
	}


}

