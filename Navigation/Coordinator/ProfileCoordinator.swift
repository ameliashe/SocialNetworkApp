//
//  LoginCoordinator.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 1/10/25.
//

import Foundation
import UIKit


class ProfileCoordinator: Coordinator {

	var navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		let profileVC = MainViewController()
		profileVC.isActiveProfile = true
		navigationController.viewControllers = [profileVC]

		UsersStoreManager().fetchUser(byLogin: CurrentUserService().currentUserID ?? "") { [weak profileVC] user in
			DispatchQueue.main.async {
				profileVC?.user = user
				profileVC?.reloadData()
			}
		}
	}
}
