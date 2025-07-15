//
//  BasePostsViewController.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 7/15/25.
//

import UIKit

class BasePostsViewController: UIViewController {
	
	//MARK: UI Elements
	lazy var displayedPostsTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.contentInsetAdjustmentBehavior = .never
		return tableView
	}()
	
	let overlayView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.alpha = 0
		return view
	}()
	
	let closeButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "xmark"), for: .normal)
		button.tintColor = .white
		button.translatesAutoresizingMaskIntoConstraints = false
		button.alpha = 0
		return button
	}()
	
	
	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		addSubviews()
		setupConstraints()
		setupCloseButton()
		setupGesture()
	}
	
	
	//MARK: Layout
	func addSubviews() {
		view.addSubview(displayedPostsTableView)
		view.addSubview(overlayView)
		view.addSubview(closeButton)
	}
	
	func setupConstraints() {
		NSLayoutConstraint.activate([
			displayedPostsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			displayedPostsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			displayedPostsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			displayedPostsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			
			overlayView.topAnchor.constraint(equalTo: view.topAnchor),
			overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
		])
	}
	
	func setupCloseButton() {
		closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
	}
	
	func setupGesture() {
	}
	
	
	//MARK: Overlay animation
	@objc func closeButtonTapped() {
		UIView.animate(withDuration: 0.3) {
			self.closeButton.alpha = 0
			self.overlayView.alpha = 0
		}
	}
}
