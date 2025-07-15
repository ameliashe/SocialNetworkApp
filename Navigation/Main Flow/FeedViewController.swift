//
//  FeedViewController.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 7/15/25.
//

import UIKit

class FeedViewController: BasePostsViewController {
	
	//MARK: Properties
	private var displayedPosts: [Post] = []
	private let viewModel = FavoritesViewModel()
	
	
	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		configureTableData()
	}
	
	
	//MARK: Layout
	func setupTableView() {
		displayedPostsTableView.rowHeight = UITableView.automaticDimension
		displayedPostsTableView.estimatedRowHeight = 200
		displayedPostsTableView.tableFooterView = UIView()
		displayedPostsTableView.contentInsetAdjustmentBehavior = .never
		
		displayedPostsTableView.register(PostCell.self, forCellReuseIdentifier: CellReuseID.base.rawValue)
		displayedPostsTableView.delegate = self
		displayedPostsTableView.dataSource = self
		displayedPostsTableView.separatorStyle = .none
	}
	
	override func setupGesture() {
		let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler))
		doubleTapGesture.numberOfTapsRequired = 2
		displayedPostsTableView.addGestureRecognizer(doubleTapGesture)
	}
	
	
	//MARK: Data
	func configureTableData() {
		PostsStoreManager().fetchAllPosts() { [weak self] posts in
			guard let posts else { return }
			self?.displayedPosts = posts
			self?.displayedPostsTableView.reloadData()
		}
	}
	
	
	//MARK: Double Tap
	@objc private func doubleTapHandler(_ gesture: UITapGestureRecognizer) {
		let location = gesture.location(in: displayedPostsTableView)
		guard let indexPath = displayedPostsTableView.indexPathForRow(at: location) else { return }
		let selectedPost = displayedPosts[indexPath.row]
		
		if viewModel.isPostSaved(selectedPost) {
			return
		} else {
			viewModel.savePost(selectedPost)
			let alertController = UIAlertController(title: NSLocalizedString("Saved to Faves!", comment: "Alert: post was saved to favorites"), message: nil, preferredStyle: .alert)
			alertController.view.layer.opacity = 0.7
			self.present(alertController, animated: true)
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				alertController.dismiss(animated: true)
			}
		}
	}
}


extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return displayedPosts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.base.rawValue, for: indexPath) as? PostCell else {
			fatalError("Could not dequeue CustomPostCell")
		}
		guard !displayedPosts.isEmpty else {
			return UITableViewCell()
		}
		cell.update(displayedPosts[indexPath.row])
		cell.selectionStyle = .none
		cell.onAuthorTap = { [weak self] in
			guard let self, let nav = self.navigationController else { return }
			let selectedPost = self.displayedPosts[indexPath.row]
			UsersStoreManager().fetchUser(byLogin: selectedPost.authorID) { user in
				guard let user = user else { return }
				DispatchQueue.main.async {
					let coordinator = ProfileCoordinator(navigationController: nav)
					let isActive = (user.login == CurrentUserService().currentUserID)
					coordinator.showProfile(for: user, isActive: isActive)
				}
			}
		}
		return cell
	}
}
