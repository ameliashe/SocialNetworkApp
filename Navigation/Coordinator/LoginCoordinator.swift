//
//  LoginCoordinator.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 1/10/25.
//

import Foundation
import UIKit


class LoginCoordinator: Coordinator {

	var navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		let logInVC = LogInViewController()

		navigationController.pushViewController(logInVC, animated: false)
	}

}
