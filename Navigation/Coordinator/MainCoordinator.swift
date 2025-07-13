//
//  Coordinator.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 1/10/25.
//

import Foundation
import UIKit

protocol Coordinator {
	var navigationController: UINavigationController { get set }
	func start()
}

class MainCoordinator: Coordinator {

	var navigationController = UINavigationController()
	var tabBarController = UITabBarController()

	var feedCoordinator: FeedCoordinator?
	var profileCoordinator: ProfileCoordinator?
	var favoritesCoordinator: FavoritesCoordinator?

	init(navigationController: UINavigationController, tabBarController: UITabBarController) {
		self.navigationController = navigationController
		self.tabBarController = tabBarController
	}

	func start() {

		let feedNC = UINavigationController()
		let profileNC = UINavigationController()
		let favNC = UINavigationController()

		feedCoordinator = FeedCoordinator(navigationController:	feedNC)
		profileCoordinator = ProfileCoordinator(navigationController: profileNC)
		favoritesCoordinator = FavoritesCoordinator(navigationController: favNC)

		feedCoordinator?.start()
		profileCoordinator?.start()
		favoritesCoordinator?.start()

		let controllers = [feedNC, profileNC, favNC]
		tabBarController.viewControllers = controllers

		feedNC.tabBarItem = UITabBarItem(title: NSLocalizedString("Feed", comment: "Feed tab bar item"), image: UIImage(systemName: "list.bullet.rectangle"), tag: 0)
		profileNC.tabBarItem = UITabBarItem(title: NSLocalizedString("Profile", comment: "Profile tab bar item"), image: UIImage(systemName: "person"), tag: 1)
		favNC.tabBarItem = UITabBarItem(title: NSLocalizedString("Favorites", comment: "Favorites tab bar item"), image: UIImage(systemName: "heart"), tag: 2)

		tabBarController.selectedIndex = 0
		tabBarController.tabBar.isTranslucent = false

		navigationController.viewControllers = [tabBarController]
		navigationController.setNavigationBarHidden(true, animated: false)
	}
	
	

}
