//
//  MainViewController.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 10/31/24.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

	//MARK: CoreData – Used for saving posts to favorites
	lazy var fetchResultsController = {

		let request = FavoritePost.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "authorID", ascending: false)]

		let frc = NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: viewModel.persistentContainer.viewContext,
			sectionNameKeyPath: nil,
			cacheName: nil
		)
		return frc
	}()

	//MARK: Properties
	var isShowingFavoritePosts: Bool = false
	var isShowingFeed: Bool = false
	var isActiveProfile: Bool = false
	var user: User?
	private var displayedPosts = [Post]()
	private let viewModel = FavoritesViewModel()

		private enum HeaderFooterReuseID: String {
		case base = "ProfileHeaderView_ID"
		case posts = "PostsHeaderView_ID"
	}

	private enum CellReuseID: String {
		case base = "ProfilePostCell_ID"
		case photos = "PhotosTableViewCell_ID"
	}


	//MARK: UI elements
	var profileHeaderView: ProfileHeaderView?
	var postsHeaderView: PostsTableHeaderView?

	lazy private var displayedPostsTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.translatesAutoresizingMaskIntoConstraints = false

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
		setupTableView()
		setupCloseButton()
		setupGesture()
		setupNavigationBar()
		configureTableData()

		fetchResultsController.delegate = self
		try? fetchResultsController.performFetch()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		configureTableData()
	}

	//MARK: Layout
	func addSubviews() {
		view.addSubview(displayedPostsTableView)
		view.addSubview(overlayView)
		view.addSubview(closeButton)
	}
	
	func setupNavigationBar() {
		if isShowingFavoritePosts {
			navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Search", comment: "Search favorites button"), style: .plain, target: self, action: #selector(filterButtonTapped))
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Clear", comment: "Clear search button"), style: .plain, target: self, action: #selector(clearButtonTapped))
		} else if isActiveProfile {
			navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "iphone.and.arrow.forward.outward"), style: .plain, target: self, action: #selector(logoutButtonTapped))
			let editProfileButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(editProfileTapped))
			let newPostButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil.circle"), style: .plain, target: self, action: #selector(newPostTapped))
			navigationItem.rightBarButtonItems = [newPostButton, editProfileButton]
		}
	}

	func setupTableView() {
		displayedPostsTableView.rowHeight = UITableView.automaticDimension
		displayedPostsTableView.estimatedRowHeight = 200
		displayedPostsTableView.tableFooterView = UIView()
		displayedPostsTableView.contentInsetAdjustmentBehavior = .never

		displayedPostsTableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderFooterReuseID.base.rawValue)
		
		displayedPostsTableView.register(PostsTableHeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderFooterReuseID.posts.rawValue)

		displayedPostsTableView.register(PostCell.self, forCellReuseIdentifier: CellReuseID.base.rawValue)

		displayedPostsTableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: CellReuseID.photos.rawValue)

		displayedPostsTableView.delegate = self
		displayedPostsTableView.dataSource = self
		displayedPostsTableView.separatorStyle = .none
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

	func setupCloseButton () {
		closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
	}

	func animateAvatarExpansion() {
		guard let profileHeaderView = self.profileHeaderView else {
			print("Header view not found")
			return
		}
		let avatar = profileHeaderView.avatarImageView
		guard let avatarSuperview = avatar.superview else {
			print("Avatar superview not found")
			return
		}

		let avatarInitialFrame = avatarSuperview.convert(avatar.frame, to: view)

		let avatarCopy = UIImageView(image: avatar.image)
		avatarCopy.frame = avatarInitialFrame
		avatarCopy.contentMode = .scaleAspectFill
		avatarCopy.layer.cornerRadius = avatar.layer.cornerRadius
		avatarCopy.layer.masksToBounds = true
		avatarCopy.tag = 999
		view.addSubview(avatarCopy)

		avatar.isHidden = true

		let targetFrame = CGRect(
			x: 0,
			y: view.center.y - (view.frame.width / 2),
			width: view.frame.width,
			height: view.frame.width
		)

		UIView.animate(withDuration: 0.3, animations: {
			self.overlayView.alpha = 1
			avatarCopy.frame = targetFrame
			avatarCopy.layer.cornerRadius = 0
		}, completion: { _ in
			UIView.animate(withDuration: 0.3) {
				self.closeButton.alpha = 1
			}
		})
	}

	func loadFavoritePosts() {
		let request = FavoritePost.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "authorID", ascending: false)]

		self.fetchResultsController = NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: self.viewModel.persistentContainer.viewContext,
			sectionNameKeyPath: nil,
			cacheName: nil
		)

		configureTableData()
	}

	//MARK: Setting up the tableView
	func configureTableData() {
		
		if isShowingFavoritePosts {
			
			//For displaying favorites
			try? fetchResultsController.performFetch()
			displayedPosts = fetchResultsController.fetchedObjects?.map { Post(entity: $0) } ?? []
			self.displayedPostsTableView.reloadData()
		} else if isShowingFeed {
			
			//For displaying Feed
			PostsStoreManager().fetchAllPosts() { [weak self] posts in
				guard let posts else { return }
				self?.displayedPosts = posts
				self?.displayedPostsTableView.reloadData()
			}
		} else {
			//For displaying profile
			let id = user?.login ?? ""
			PostsStoreManager().fetchPosts(byAuthor: id) { [weak self] posts in
				guard let posts else { return }
				self?.displayedPosts = posts
				self?.displayedPostsTableView.reloadData()
			}
		}
	}
	


	//MARK: User Interaction
	@objc private func closeButtonTapped() {
		guard let avatarCopy = view.viewWithTag(999) as? UIImageView else { return }

		UIView.animate(withDuration: 0.3, animations: {
			self.closeButton.alpha = 0
		})

		guard let headerView = self.profileHeaderView else {
			print("Header view not found")
			return
		}
		let avatar = headerView.avatarImageView
		guard let avatarSuperview = avatar.superview else {
			print("Avatar superview not found")
			return
		}
		let avatarInitialFrame = avatarSuperview.convert(avatar.frame, to: view)


		UIView.animate(withDuration: 0.5, animations: {
			self.overlayView.alpha = 0
			avatarCopy.frame = avatarInitialFrame
			avatarCopy.layer.cornerRadius = avatar.frame.height / 2
		}, completion: { _ in
			avatarCopy.removeFromSuperview()
			avatar.isHidden = false
		})
	}

	func setupGesture() {
		let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler))
		doubleTapGesture.numberOfTapsRequired = 2
		displayedPostsTableView.addGestureRecognizer(doubleTapGesture)
	}

	@objc private func doubleTapHandler(_ gesture: UITapGestureRecognizer) {
		let location = gesture.location(in: displayedPostsTableView)
		guard let indexPath = displayedPostsTableView.indexPathForRow(at: location) else { return }
		
		if isShowingFeed {
			guard indexPath.section == 0 else { return }
		} else {
			guard indexPath.section == 1 else { return }
		}

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

	@objc func filterButtonTapped() {
		let alertvc = UIAlertController(title: NSLocalizedString("Search by author", comment: "Title of search window of favorites by author"), message: nil, preferredStyle: .alert)
		alertvc.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button title"), style: .cancel))
		alertvc.addTextField { textField in
			textField.placeholder = NSLocalizedString("Author's name", comment: "TextField placeholder for entering author's name")
		}
		alertvc.addAction(UIAlertAction(title: NSLocalizedString("Search", comment: "Search button title"), style: .default, handler: { [weak self] _ in
			guard let self = self else {
				return
			}
			guard let textField = alertvc.textFields?.first else {
				return
			}
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
				configureTableData()
			} else {
				try? fetchResultsController.performFetch()
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
		configureTableData()
	}
	
	@objc func editProfileTapped() {
		let vc = EditProfileViewController()
		vc.user = self.user
		vc.modalPresentationStyle = .pageSheet
		present(vc, animated: true)
	}
	
	@objc func logoutButtonTapped() {
		let checkerService = CheckerService()
		checkerService.logout { result in
			DispatchQueue.main.async {
				switch result {
				case .success:
					CurrentUserService().clearCurrentUser()
					
					let loginVC = LogInViewController()
					let nav = UINavigationController(rootViewController: loginVC)
					nav.modalPresentationStyle = .fullScreen
					self.view.window?.rootViewController = nav
				case .failure(let error):
					print("Couldn't logout:", error)
				}
			}
		}
	}
	
	@objc func newPostTapped() {
		let vc = NewPostViewController()
		vc.modalPresentationStyle = .pageSheet
		present(vc, animated: true)
	}
	
	public func reloadData() {
		configureTableData()
		displayedPostsTableView.reloadData()
	}
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if isShowingFeed { return nil }
		
		//Profile Header with user details
		if section == 0 && !isShowingFavoritePosts {
			guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderFooterReuseID.base.rawValue) as? ProfileHeaderView else {
				return nil
			}
			
			if let user = user {
				headerView.configure(with: user, postsCount: displayedPosts.count)
			}
			
			headerView.avatarTapped = { [weak self] in
				guard let self = self else { return }
				self.animateAvatarExpansion()
			}
			self.profileHeaderView = headerView
			return headerView
			
		} else
		
		//Rounded header for posts in profile
		if (section == 1 && !isShowingFavoritePosts) || (section == 0 && !isActiveProfile && !isShowingFavoritePosts && !isShowingFeed) {
			guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderFooterReuseID.posts.rawValue) as? PostsTableHeaderView else {
				return nil
			}
			
			self.postsHeaderView = headerView
			return headerView
		}
		
		return nil
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return isShowingFavoritePosts || isShowingFeed ? displayedPosts.count : 1
		}
		return isShowingFavoritePosts || isShowingFeed ? 0 : displayedPosts.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//Photos Panel in Profile
		if indexPath.section == 0 && !isShowingFavoritePosts && !isShowingFeed && isActiveProfile {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.photos.rawValue, for: indexPath) as? PhotosTableViewCell else {
				fatalError("Could not dequeue PhotosTableViewCell")
			}
			cell.selectionStyle = .none
			return cell
		}

		//Cell for posts in the Profile and in the Favorites
		if (indexPath.section == 0 && (isShowingFavoritePosts || isShowingFeed || !isActiveProfile)) || (indexPath.section == 1 && (!isShowingFavoritePosts)) {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.base.rawValue, for: indexPath) as? PostCell else {
				fatalError("Could not dequeue CustomPostCell")
			}
			guard !displayedPosts.isEmpty else {
				return UITableViewCell()
			}
			cell.update(displayedPosts[indexPath.row])
			cell.selectionStyle = .none
			if isShowingFeed || isShowingFavoritePosts {
				cell.onAuthorTap = { [weak self] in
					guard let self else { return }

					let selectedPost = self.displayedPosts[indexPath.row]
					let profileVC = MainViewController()

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
			}
			return cell
		} else {
			return UITableViewCell()
		}
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if isShowingFeed { return 0 }
		return isShowingFavoritePosts ? 0 : (section == 1 ? 30 : 300)
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		//Push Photo Gallery
		if indexPath.section == 0  && !isShowingFavoritePosts && !isShowingFeed && isActiveProfile {
			let galleryVC = PhotoGalleryViewController()
			navigationController?.pushViewController(galleryVC, animated: true)
		}
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return (isShowingFavoritePosts && indexPath.section == 0) ||
			   (isActiveProfile && !isShowingFeed && indexPath.section == 1)
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if isShowingFavoritePosts {
			if editingStyle == .delete {
				let favoritePost = fetchResultsController.object(at: indexPath)
				viewModel.persistentContainer.viewContext.delete(favoritePost)

				try? viewModel.persistentContainer.viewContext.save()
			}
		} else if !isShowingFavoritePosts && !isShowingFeed {
			let post = displayedPosts[indexPath.row]
			guard post.authorID == CurrentUserService().currentUserID, let postID = post.id else { return }
			PostsStoreManager().delete(postID: postID) { [weak self] error in
				DispatchQueue.main.async {
					if let error = error {
						print("Failed to delete post:", error)
					} else {
						self?.displayedPosts.remove(at: indexPath.row)
						self?.displayedPostsTableView.deleteRows(at: [indexPath], with: .automatic)
					}
				}
			}
		}
	}
}

extension MainViewController: NSFetchedResultsControllerDelegate {

	func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

		if isShowingFavoritePosts {

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
