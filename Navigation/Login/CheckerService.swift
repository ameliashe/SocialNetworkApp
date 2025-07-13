//
//  CheckerService.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 2/10/25.
//

import Foundation
import FirebaseAuth

enum AuthError: Error {
	case userNotFound
	case wrongPassword
	case emailAlreadyInUse
	case unknownError
}

protocol CheckerServiceProtocol {

	func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void)
	
	func signUp(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void)
	
	func isAuthorized () -> Bool
	
	func logout(completion: @escaping (Result<Void, Error>) -> Void)
}

class CheckerService: CheckerServiceProtocol {

	func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {

		Auth.auth().signIn(withEmail:  email, password: password) { authResult, error in
			if let error = error as NSError? {
				if error.code == AuthErrorCode.userNotFound.rawValue {
					completion(.failure(.userNotFound))
				} else if error.code == AuthErrorCode.wrongPassword.rawValue {
					completion(.failure(.wrongPassword))
				} else {
					completion(.failure(.unknownError))
				}

			} else {
				completion(.success(()))
			}
		}
	}

	func signUp(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {

		Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
			if let error = error as NSError? {
				if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
					completion(.failure(.emailAlreadyInUse))
				} else {
					completion(.failure(.unknownError))
				}
			} else {
				completion(.success(()))
			}
		}
	}

	func isAuthorized () -> Bool {
		return Auth.auth().currentUser != nil
	}
	
	func logout(completion: @escaping (Result<Void, Error>) -> Void) {
		do {
			try Auth.auth().signOut()
			// Очистка локального ID
			CurrentUserService().clearCurrentUser()
			completion(.success(()))
		} catch {
			completion(.failure(error))
		}
	}
}
