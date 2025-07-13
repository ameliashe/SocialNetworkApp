//
//  EditProfileViewController.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 7/11/25.
//

import UIKit

class EditProfileViewController: UIViewController {
	
	var user: User?
	
	private let fullNameField = TextFieldStackView(title: NSLocalizedString("Name", comment: "Name field annotation in EditProfileVC"))
	private let cityField = TextFieldStackView(title: NSLocalizedString("City", comment: "City field annotation in EditProfileVC"))
	private let statusField = TextFieldStackView(title: NSLocalizedString("Status", comment: "Status field annotation in EditProfileVC"))
	private let avatarField = TextFieldStackView(title: NSLocalizedString("Avatar", comment: "Avatar field annotation in EditProfileVC"))
	
	private lazy var saveButton = CustomButton(title:  NSLocalizedString("Save", comment: "Save button in EditProfileVC")) { [weak self] in
		self?.saveButtonTapped()
	}
	
	init(user: User? = nil) {
		super.init(nibName: nil, bundle: nil)
		self.user = user
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		populateFields()
	}
	
	private func setupUI() {
		
		[fullNameField, cityField, statusField, avatarField, saveButton].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
		
		saveButton.setTitle("Save", for: .normal)
		saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
		
		NSLayoutConstraint.activate([
			fullNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			fullNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			fullNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			cityField.topAnchor.constraint(equalTo: fullNameField.bottomAnchor, constant: 20),
			cityField.leadingAnchor.constraint(equalTo: fullNameField.leadingAnchor),
			cityField.trailingAnchor.constraint(equalTo: fullNameField.trailingAnchor),
			
			statusField.topAnchor.constraint(equalTo: cityField.bottomAnchor, constant: 20),
			statusField.leadingAnchor.constraint(equalTo: fullNameField.leadingAnchor),
			statusField.trailingAnchor.constraint(equalTo: fullNameField.trailingAnchor),
			
			avatarField.topAnchor.constraint(equalTo: statusField.bottomAnchor, constant: 20),
			avatarField.leadingAnchor.constraint(equalTo: fullNameField.leadingAnchor),
			avatarField.trailingAnchor.constraint(equalTo: fullNameField.trailingAnchor),
			
			saveButton.topAnchor.constraint(equalTo: avatarField.bottomAnchor, constant: 40),
			saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			saveButton.heightAnchor.constraint(equalToConstant: 44),
			saveButton.widthAnchor.constraint(equalToConstant: 200)
		])
	}
	
	private func populateFields() {
		fullNameField.textField.text = user?.fullName
		cityField.textField.text = user?.city
		statusField.textField.text = user?.status
		avatarField.textField.text = user?.avatar
	}
	
	@objc private func saveButtonTapped() {
		guard let updatedUser = user else { return }
		updatedUser.fullName = fullNameField.textField.text ?? ""
		updatedUser.city = cityField.textField.text ?? ""
		updatedUser.status = statusField.textField.text ?? ""
		guard let text = avatarField.textField.text,
			  let url = URL(string: text),
			  url.scheme != nil else {
			let alert = UIAlertController(
				title: NSLocalizedString("Invalid URL", comment: "Invalid URL alert title"),
				message: NSLocalizedString("Please enter a valid URL.", comment: "Invalid URL alert message"),
				preferredStyle: .alert
			)
			alert.addAction(UIAlertAction(title: "OK", style: .default))
			present(alert, animated: true)
			return
		}
		updatedUser.avatar = text
		
		UsersStoreManager().updateUser(updatedUser) { [weak self] error in
			DispatchQueue.main.async {
				guard let self = self else { return }
				if let error = error {
					let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error alert title"), message: error.localizedDescription, preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "OK", style: .default))
					self.present(alert, animated: true)
				} else {
					self.dismiss(animated: true, completion: nil)
				}
			}
		}
	}
}
