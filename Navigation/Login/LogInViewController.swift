//
//  LogInViewController.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 11/5/24.
//

import UIKit
import KeychainSwift

class LogInViewController: UIViewController {
	
	//MARK: Properties
	var userID: String?
	private let keychain = KeychainSwift()

	//MARK: LoginService
	private var loginDelegate: LoginViewControllerDelegate? = LoginInspector()
	private let biometry = LocalAuthorizationService.shared.checkBiometryType()

	//MARK: UI Elements
	private lazy var credentialsStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [usernameTextField, separatorView, passwordTextField])
		stackView.axis = .vertical
		stackView.spacing = 0
		stackView.distribution = .fill
		stackView.layer.cornerRadius = 12
		stackView.layer.borderWidth = 0.5
		stackView.layer.borderColor = UIColor.lightGray.cgColor
		stackView.layer.masksToBounds = true
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private lazy var usernameTextField: BasicTextField = {
		let textField = BasicTextField()
		textField.placeholder = NSLocalizedString("Email or phone", comment: "Username input placeholder")
#if DEBUG
		textField.text = "test@test.com"
#endif
		textField.autocapitalizationType = .none
		return textField
	}()

	private lazy var passwordTextField: BasicTextField = {
		let textField = BasicTextField()
		textField.placeholder = NSLocalizedString("Password", comment: "Password input placeholder")
#if DEBUG
		textField.text = "123456"
#endif
		textField.autocapitalizationType = .none
		textField.isSecureTextEntry = true
		return textField
	}()

	private let separatorView: UIView = {
		let view = UIView()
		view.backgroundColor = .lightGray
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		return scrollView
	}()

	private let contentView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private let logoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "logo-2")
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private lazy var loginButton = CustomButton(title: NSLocalizedString("Log In", comment: "Login button title")) { [weak self] in
		self?.logInButtonTapped()
	}

	private lazy var signUpButton = CustomButton(title: NSLocalizedString("Sign Up", comment: "Sign up button title")) { [weak self] in
		self?.signUpButtonTapped()
	}

	let credentialsIndicator: UIActivityIndicatorView = {
		let activityIndicatorView = UIActivityIndicatorView(style: .medium)
		activityIndicatorView.hidesWhenStopped = true
		activityIndicatorView.style = .medium
		activityIndicatorView.color = UIColor(named: "AccentColor")
		activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		return activityIndicatorView
	}()

	private lazy var biometricButton = CustomImageButton(image: UIImage(systemName: (biometry == "Face ID") ? "faceid" : "touchid")!) { [weak self] in
		guard let self = self else { return }
		LocalAuthorizationService.shared.authorizeIfPossible { result, error in

			if result == true {
				self.logInButtonTapped()
			} else {
				let message = error?.localizedDescription
				self.showErrorAlert(message: message ?? "")
			}
		}
	}

	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		if loginDelegate?.isAuthorized() == true {
			navigateToProfile()
		}

		if biometry != "Face ID" || biometry != "Touch ID" {
			biometricButton.isHidden = false
		}

		viewSetup()
		layoutConstraintsSetup()

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		setupKeyboardObservers()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		removeKeyboardObservers()
	}

	//MARK: UI Setup
	private func viewSetup() {
		navigationController?.navigationBar.isHidden = true
		view.backgroundColor = ColorPalette.customBackground

		contentView.addSubview(logoImageView)
		contentView.addSubview(credentialsStackView)
		contentView.addSubview(loginButton)
		contentView.addSubview(credentialsIndicator)
		contentView.addSubview(signUpButton)
		contentView.addSubview(biometricButton)

		scrollView.addSubview(contentView)
		view.addSubview(scrollView)
	}

	private func layoutConstraintsSetup() {
		NSLayoutConstraint.activate([
			logoImageView.widthAnchor.constraint(equalToConstant: 250),
			logoImageView.heightAnchor.constraint(equalToConstant: 250),
			logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
			logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

			credentialsStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
			credentialsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			credentialsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			credentialsStackView.heightAnchor.constraint(equalToConstant: 100),

			loginButton.heightAnchor.constraint(equalToConstant: 50),
			loginButton.topAnchor.constraint(equalTo: credentialsStackView.bottomAnchor, constant: 16),
			loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),


			usernameTextField.leadingAnchor.constraint(equalTo: credentialsStackView.leadingAnchor),
			usernameTextField.trailingAnchor.constraint(equalTo: credentialsStackView.trailingAnchor),
			usernameTextField.heightAnchor.constraint(equalToConstant: 50),

			passwordTextField.leadingAnchor.constraint(equalTo: credentialsStackView.leadingAnchor),
			passwordTextField.trailingAnchor.constraint(equalTo: credentialsStackView.trailingAnchor),
			passwordTextField.heightAnchor.constraint(equalToConstant: 50),


			separatorView.leadingAnchor.constraint(equalTo: credentialsStackView.leadingAnchor),
			separatorView.trailingAnchor.constraint(equalTo: credentialsStackView.trailingAnchor),
			separatorView.heightAnchor.constraint(equalToConstant: 0.5),

			contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			credentialsIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			credentialsIndicator.bottomAnchor.constraint(equalTo: credentialsStackView.centerYAnchor),
			credentialsIndicator.heightAnchor.constraint(equalToConstant: 150),
			credentialsIndicator.widthAnchor.constraint(equalToConstant: 150),

			signUpButton.leadingAnchor.constraint(equalTo: credentialsStackView.leadingAnchor),
			signUpButton.trailingAnchor.constraint(equalTo: credentialsStackView.trailingAnchor),
			signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
			signUpButton.heightAnchor.constraint(equalToConstant: 50),

			biometricButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
			biometricButton.heightAnchor.constraint(equalToConstant: 50),
			biometricButton.widthAnchor.constraint(equalToConstant: 50),
			biometricButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

			biometricButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

		])
	}

	//MARK: Keyboard management
	private func setupKeyboardObservers() {
		let notificationCenter = NotificationCenter.default

		notificationCenter.addObserver(
			self,
			selector: #selector(self.willShowKeyboard(_:)),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)

		notificationCenter.addObserver(
			self,
			selector: #selector(self.willHideKeyboard(_:)),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}

	private func removeKeyboardObservers() {
		let notificationCenter = NotificationCenter.default
		notificationCenter.removeObserver(self)
	}

	@objc func willShowKeyboard(_ notification: NSNotification) {
		let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
		scrollView.contentInset.bottom += keyboardHeight ?? 0.0
	}

	@objc func willHideKeyboard(_ notification: NSNotification) {
		scrollView.contentInset.bottom = 0.0
	}

	//MARK: User Interaction Methods
	private func logInButtonTapped() {
		guard let email = usernameTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
			showErrorAlert(message: NSLocalizedString("Username and password cannot be empty", comment: "Error message for empty login and password"))
			return
		}

		loginButton.isEnabled = false
		signUpButton.isEnabled = false
		credentialsIndicator.startAnimating()

		loginDelegate?.checkCredentials(email: email, password: password) { [weak self] result in

			DispatchQueue.main.async {
				self?.credentialsIndicator.stopAnimating()
				self?.loginButton.isEnabled = true
				self?.signUpButton.isEnabled = true

				switch result {
				case .success():
					let emailParts = email.components(separatedBy: "@")
					if let id = emailParts.first {
						self?.keychain.set(id, forKey: "userID")
					}
					self?.navigateToProfile()
				case .failure(let error):
					self?.handleAuthError(error)
				}
			}
		}
	}

	private func signUpButtonTapped() {
		guard let email = usernameTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
			showErrorAlert(message: NSLocalizedString("Username and password cannot be empty", comment: "Error message for empty login and password"))
			return
		}
		loginButton.isEnabled = false
		signUpButton.isEnabled = false
		credentialsIndicator.startAnimating()

		loginDelegate?.signUp(email: email, password: password) { [weak self] result in
			DispatchQueue.main.async {
				self?.credentialsIndicator.stopAnimating()
				self?.loginButton.isEnabled = true
				self?.signUpButton.isEnabled = true

				switch result {
				case .success():
					self?.navigateToProfile()
				case .failure(let error):
					self?.handleAuthError(error)
				}
			}
		}
	}

	private func navigateToProfile() {
		let tabBar = UITabBarController()
		let mainNС = UINavigationController()
		let mainCoordinator = MainCoordinator(
			navigationController: mainNС,
			tabBarController: tabBar
		)
		mainCoordinator.start()
		
		navigationController?.setViewControllers([tabBar], animated: true)
	}

	private func handleAuthError(_ error: AuthError) {
		switch error {
		case .userNotFound:
			showErrorAlert(message: NSLocalizedString("User not found. Please sign up.", comment: "Error message for user not found"))
		case .wrongPassword:
			showErrorAlert(message: NSLocalizedString("Wrong password", comment: "Error message for wrong password"))
		case .emailAlreadyInUse:
			showErrorAlert(message: NSLocalizedString("This email is already in use", comment: "Error message for email already in use"))
		case .unknownError:
			showErrorAlert(message: NSLocalizedString("Unknown error occurred. Please try again later.", comment: "Error message for unknown error"))
		}
	}

	private func showErrorAlert(message: String) {
		let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Alert title for error"), message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	}
}

protocol LoginViewControllerDelegate: AnyObject {

	func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void)

	func signUp(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void)

	func isAuthorized() -> Bool
}

class LoginInspector: LoginViewControllerDelegate {

	private let checkerService: CheckerServiceProtocol = CheckerService()

	func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
		checkerService.checkCredentials(email: email, password: password, completion: completion)
	}

	func signUp(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
		checkerService.signUp(email: email, password: password, completion: completion)
	}

	func isAuthorized() -> Bool {
			return checkerService.isAuthorized()
		}
}
