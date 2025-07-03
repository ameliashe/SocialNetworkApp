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
		feedVC.title = NSLocalizedString("Feed", comment: "Feed Navigation Bar Title")
		feedVC.navigationItem.largeTitleDisplayMode = .automatic
		navigationController.navigationBar.prefersLargeTitles = true
		
		navigationController.pushViewController(feedVC, animated: false)
	}

}
