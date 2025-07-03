//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 7/3/25.
//

import Foundation
import KeychainSwift

final class CurrentUserService {
	var currentUser: String? {
		KeychainSwift().get("userID")
	}
}
