//
//  Errors.swift
//  Navigation
//
//  Created by Amelia Romanova on 1/28/25.
//

import Foundation

//MARK: Errors
enum AppError: Error {
	case invalidCredentials
	case userNotFound
	case passwordGuessingFailed
	case unknownError
}
