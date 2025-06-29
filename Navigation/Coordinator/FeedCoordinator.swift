//
//  Coordinator.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 1/10/25.
//

import Foundation
import UIKit

class FeedCoordinator: Coordinator {

	var navigationController: UINavigationController


	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {

		let feedVC = MainViewController()
		feedVC.isShowingFeed = true
		feedVC.postsList = posts

		navigationController.pushViewController(feedVC, animated: false)
	}

}
