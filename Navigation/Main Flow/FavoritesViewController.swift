//
//  FavoritesViewController.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 7/15/25.
//

import UIKit
import CoreData

class FavoritesViewController: BasePostsViewController {
	
	
	//MARK: Properties
	private var displayedPosts: [Post] = []
	private let viewModel = FavoritesViewModel()
	lazy var fetchResultsController: NSFetchedResultsController<FavoritePost> = {
		let request = FavoritePost.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "authorID", ascending: false)]
		let frc = NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: viewModel.persistentContainer.viewContext,
			sectionNameKeyPath: nil,
			cacheName: nil
		)
		frc.delegate = self
		return frc
	}()
	
	
	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		setupNavigationBar()
		configureTableData()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		configureTableData()
	}
	
	
	//MARK: Layout
	func setupNavigationBar() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			title: NSLocalizedString("Search", comment: "Search favorites button"),
			style: .plain,
			target: self,
			action: #selector(filterButtonTapped)
		)
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: NSLocalizedString("Clear", comment: "Clear search button"),
			style: .plain,
			target: self,
			action: #selector(clearButtonTapped)
		)
	}
	
	func setupTableView() {
		displayedPostsTableView.rowHeight = UITableView.automaticDimension
		displayedPostsTableView.estimatedRowHeight = 200
		displayedPostsTableView.tableFooterView = UIView()
		displayedPostsTableView.contentInsetAdjustmentBehavior = .never
		displayedPostsTableView.sectionHeaderTopPadding = 0
		
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
		try? fetchResultsController.performFetch()
		displayedPosts = fetchResultsController.fetchedObjects?.map { Post(entity: $0) } ?? []
		displayedPostsTableView.reloadData()
	}
	
	
	//MARK: User Interaction
	@objc func filterButtonTapped() {
		let alertvc = UIAlertController(title: NSLocalizedString("Search by author", comment: "Title of search window of favorites by author"), message: nil, preferredStyle: .alert)
		alertvc.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button title"), style: .cancel))
		alertvc.addTextField { textField in
			textField.placeholder = NSLocalizedString("Author's name", comment: "TextField placeholder for entering author's name")
		}
		alertvc.addAction(UIAlertAction(title: NSLocalizedString("Search", comment: "Search button title"), style: .default, handler: { [weak self] _ in
			guard let self = self, let textField = alertvc.textFields?.first else { return }
			if let text = textField.text, !text.isEmpty {
				let request = FavoritePost.fetchRequest()
				request.sortDescriptors = [NSSortDescriptor(key: "authorID", ascending: false)]
				request.predicate = NSPredicate(format: "authorID CONTAINS[cd] %@", text)
				self.fetchResultsController = NSFetchedResultsController(
					fetchRequest: request,
					managedObjectContext: self.viewModel.persistentContainer.viewContext,
					sectionNameKeyPath: nil,
					cacheName: nil
				)
				self.fetchResultsController.delegate = self
				try? self.fetchResultsController.performFetch()
				self.configureTableData()
			} else {
				try? self.fetchResultsController.performFetch()
				self.configureTableData()
			}
		}))
		present(alertvc, animated: true)
	}
	
	@objc func clearButtonTapped() {
		let request = FavoritePost.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "authorID", ascending: false)]
		self.fetchResultsController = NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: viewModel.persistentContainer.viewContext,
			sectionNameKeyPath: nil,
			cacheName: nil
		)
		self.fetchResultsController.delegate = self
		try? self.fetchResultsController.performFetch()
		configureTableData()
	}
	
	
	//MARK: Double Tap Handler
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


extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
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
			guard let self = self else { return }
			let selectedPost = self.displayedPosts[indexPath.row]
			let profileVC = ProfileViewController()
			UsersStoreManager().fetchUser(byLogin: selectedPost.authorID) { user in
				guard let user = user else { return }
				DispatchQueue.main.async {
					profileVC.user = user
					profileVC.navigationItem.largeTitleDisplayMode = .never
					profileVC.navigationController?.isToolbarHidden = false
					profileVC.title = user.login
					self.navigationController?.pushViewController(profileVC, animated: true)
				}
			}
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let favoritePost = fetchResultsController.object(at: indexPath)
			viewModel.persistentContainer.viewContext.delete(favoritePost)
			try? viewModel.persistentContainer.viewContext.save()
		}
	}

	// Убираем стандартный «offset» первой секции в .grouped таблице
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return .leastNormalMagnitude   // ≈ 0.00001
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return UIView(frame: .zero)    // пустой header
	}
}


extension FavoritesViewController: NSFetchedResultsControllerDelegate {
	func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			displayedPostsTableView.insertRows(at: [newIndexPath!], with: .automatic)
			configureTableData()
		case .delete:
			displayedPostsTableView.deleteRows(at: [indexPath!], with: .automatic)
			configureTableData()
		case .move:
			displayedPostsTableView.moveRow(at: indexPath!, to: newIndexPath!)
			configureTableData()
		case .update:
			displayedPostsTableView.reloadData()
		@unknown default:
			break
		}
	}
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
		displayedPostsTableView.beginUpdates()
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
		displayedPostsTableView.endUpdates()
		if let fetchedObjects = controller.fetchedObjects as? [FavoritePost] {
			displayedPosts = fetchedObjects.map { Post(entity: $0) }
		}
	}
}
