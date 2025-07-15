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
		let profileVC = ProfileViewController()
		profileVC.isActiveProfile = true
		navigationController.viewControllers = [profileVC]

		UsersStoreManager().fetchUser(byLogin: CurrentUserService().currentUserID ?? "") { [weak profileVC] user in
			DispatchQueue.main.async {
				profileVC?.user = user
				profileVC?.displayedPostsTableView.reloadData()
			}
		}
	}
	
	
	//MARK: External profile presentation
	func showProfile(for user: User, isActive: Bool = false) {
		let profileVC = ProfileViewController()
		profileVC.user = user
		profileVC.isActiveProfile = isActive
		profileVC.navigationItem.largeTitleDisplayMode = .never
		profileVC.navigationController?.isToolbarHidden = false
		profileVC.title = user.login
		navigationController.pushViewController(profileVC, animated: true)
	}
}
