//
//  FavoritesCoordinator.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 1/10/25.
//

import Foundation
import UIKit

class FavoritesCoordinator: Coordinator {

	var navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		let favoritesVC = FavoritesViewController()
		favoritesVC.title = NSLocalizedString("Favorites", comment: "Favorites Navigation Bar Title")
		favoritesVC.navigationItem.largeTitleDisplayMode = .automatic
		navigationController.pushViewController(favoritesVC, animated: false)
	}
}
