//
//  LoginTests.swift
//  NavigationTests
//
//  Created by Amelia Shekikhacheva on 4/19/25.
//

import XCTest
@testable import Navigation

final class LoginTests: XCTestCase {

	fileprivate	var sut: MockLogInViewController!

	override func setUp() {
		super.setUp()
		sut = MockLogInViewController()
		_ = sut.view
		sut.usernameTextField.text = ""
		sut.passwordTextField.text = ""
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	func testLogInButtonTappedEmptyFields() {
		sut.usernameTextField.text = ""
		sut.passwordTextField.text = ""
		sut.logInButtonTapped()
		XCTAssertTrue(sut.didShowAlert)
		XCTAssertEqual(sut.alertMessage, "Username and password cannot be empty")
	}

	func testSignUpButtonTappedEmptyFields() {
		sut.usernameTextField.text = ""
		sut.passwordTextField.text = ""
		sut.signUpButtonTapped()
		XCTAssertTrue(sut.didShowAlert)
		XCTAssertEqual(sut.alertMessage, "Username and password cannot be empty")
	}

	func testHandleAuthErrorUserNotFound() {
		sut.handleAuthError(.userNotFound)
		XCTAssertTrue(sut.didShowAlert)
		XCTAssertEqual(sut.alertMessage, "User not found. Please sign up.")
	}

	func testHandleAuthErrorWrongPassword() {
		sut.handleAuthError(.wrongPassword)
		XCTAssertTrue(sut.didShowAlert)
		XCTAssertEqual(sut.alertMessage, "Wrong password")
	}

	func testNavigateToProfile_pushesProfileViewController() {
		sut.navigateToProfile()
		XCTAssertTrue(sut.didNavigate)
	}
}

private class MockLogInViewController: LogInViewController {
	var didShowAlert = false
	var alertMessage: String?
	var didNavigate = false
	var nextAuthResult: Result<Void, AuthError>?

	override func showErrorAlert(message: String) {
		didShowAlert = true
		alertMessage = message
	}

	override func navigateToProfile() {
		didNavigate = true
	}

	func authenticate(username: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
		if let result = nextAuthResult {
			completion(result)
		} else {
			authenticate(username: username, password: password, completion: completion)
		}
	}
}
