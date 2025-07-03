//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 4/21/25.
//

import Foundation
import LocalAuthentication
import UIKit

class LocalAuthorizationService {
	static let shared = LocalAuthorizationService()

	func authorizeIfPossible(_ authorizationFinished: @escaping (Bool, Error?) -> Void) {
		let context = LAContext()
		var laError: NSError?
		let policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics

		let canEval = context.canEvaluatePolicy(policy, error: &laError)
		print("canEvaluatePolicy =", canEval, "error:", laError as Any)
		print("biometryType =", context.biometryType)

		context.localizedCancelTitle = NSLocalizedString("Cancel authentication with \(checkBiometryType())", comment: "cancel bio button")

		guard context.canEvaluatePolicy(policy, error: &laError) else {
			authorizationFinished(false, laError)
			return
		}

		Task {
			do {
				try await context.evaluatePolicy(policy, localizedReason: "Log in to your account")
				await MainActor.run { authorizationFinished(true, nil)
				}
			} catch {
				let error = laError
				await MainActor.run { authorizationFinished(false, error)
				}
			}
		}
	}

	func checkBiometryType() -> String {
		let context = LAContext()
		_ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
		switch context.biometryType {
		case .faceID: return "Face ID"
		case .touchID: return "Touch ID"
		default:      return ""
		}
	}
}
