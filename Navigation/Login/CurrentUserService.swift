//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 7/3/25.
//

import Foundation
import KeychainSwift

final class CurrentUserService {
	var currentUserID: String? {
		KeychainSwift().get("userID")
	}
	
 func clearCurrentUser() {
	 KeychainSwift().delete("userID")
 }
}
