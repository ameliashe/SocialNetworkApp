//
//  NewPostViewController.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 7/13/25.
//

import UIKit

class NewPostViewController: UIViewController {
	
	private let textLabel: HeadlineLabel = {
		let label = HeadlineLabel(title: NSLocalizedString("Text", comment: "Label for post text"))
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let contentTextView: CustomTextView = {
		let tv = CustomTextView()
		tv.translatesAutoresizingMaskIntoConstraints = false
		return tv
	}()
	
	private let urlLabel: HeadlineLabel = {
		let label = HeadlineLabel(title: NSLocalizedString("Photo URL", comment: "Label for photo URL"))
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let photoURLTextField: SingleTextField = {
		let tf = SingleTextField()
		tf.placeholder = NSLocalizedString("Enter image URL", comment: "Placeholder for photo URL")
		tf.translatesAutoresizingMaskIntoConstraints = false
		tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
		return tf
	}()
	
	private lazy var postButton: CustomButton = {
		let button = CustomButton(title: NSLocalizedString("Post", comment: "Post button title")) { [weak self] in
			self?.didTapPost()
		}
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		title = NSLocalizedString("New Post", comment: "Title for new post screen")
		setupUI()
	}
	
	private func setupUI() {
		view.addSubview(textLabel)
		view.addSubview(contentTextView)
		view.addSubview(urlLabel)
		view.addSubview(photoURLTextField)
		view.addSubview(postButton)
		
		NSLayoutConstraint.activate([
			textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			
			contentTextView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 8),
			contentTextView.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
			contentTextView.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor),
			contentTextView.heightAnchor.constraint(equalToConstant: 300),
			
			urlLabel.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 20),
			urlLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
			urlLabel.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor),
			
			photoURLTextField.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 8),
			photoURLTextField.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
			photoURLTextField.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor),
			
			postButton.topAnchor.constraint(equalTo: photoURLTextField.bottomAnchor, constant: 20),
			postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			postButton.heightAnchor.constraint(equalToConstant: 44),
			postButton.widthAnchor.constraint(equalToConstant: 200)
		])
	}
	
	@objc private func didTapPost() {
		guard let authorID = CurrentUserService().currentUserID else { return }
		
		guard let urlString = photoURLTextField.text,
			  let url = URL(string: urlString),
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
		
		let timestamp = Int(Date().timeIntervalSince1970)
		let post = Post(authorID: authorID, description: contentTextView.text ?? "", image: urlString, likes: 0, views: 0, postTime: timestamp)
		PostsStoreManager().save(post: post) { error in
			let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error alert title"), message: error?.localizedDescription, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default))
			self.present(alert, animated: true)
		}
	}
}
