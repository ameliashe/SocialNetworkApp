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
		let favoritesVC = MainViewController()
		favoritesVC.isShowingFavoritePosts = true

		navigationController.pushViewController(favoritesVC, animated: false)
	}

}
