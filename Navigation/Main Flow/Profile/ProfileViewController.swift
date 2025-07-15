//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 7/15/25.
//

import UIKit

enum HeaderFooterReuseID: String {
	case base = "ProfileHeaderView_ID"
	case posts = "PostsHeaderView_ID"
}

enum CellReuseID: String {
	case base = "PostCell_ID"
	case photos = "PhotosTableViewCell_ID"
}


class ProfileViewController: BasePostsViewController {
	
	//MARK: Properties
	var user: User?
	private var displayedPosts = [Post]()
	private var profileHeaderView: ProfileHeaderView?
	private var postsHeaderView: PostsTableHeaderView?
	var isActiveProfile = Bool()
	
	convenience init(user: User?) {
		self.init()
		self.user = user
	}
	
	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBar()
		setupTableView()
		configureTableData()
	}
	
	
	//MARK: Layout
	func setupNavigationBar() {
		if isActiveProfile {
			if let baseIcon = UIImage(systemName: "iphone.and.arrow.forward.outward"), let cg = baseIcon.cgImage {
				let logoutIcon = UIImage(cgImage: cg, scale: baseIcon.scale/1.2, orientation: .upMirrored)
				navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoutIcon, style: .plain, target: self, action: #selector(logoutButtonTapped))
			}
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
	
	override func setupGesture() {
		let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler))
		doubleTapGesture.numberOfTapsRequired = 2
		displayedPostsTableView.addGestureRecognizer(doubleTapGesture)
	}
	
	@objc private func doubleTapHandler(_ gesture: UITapGestureRecognizer) {
		let location = gesture.location(in: displayedPostsTableView)
		guard let indexPath = displayedPostsTableView.indexPathForRow(at: location), indexPath.section == 1 else { return }
		
	}
	
	
	//MARK: Data
	func configureTableData() {
		let id = user?.login ?? ""
		PostsStoreManager().fetchPosts(byAuthor: id) { [weak self] posts in
			guard let posts else { return }
			self?.displayedPosts = posts
			self?.displayedPostsTableView.reloadData()
		}
	}
	
	
	//MARK: User Interaction
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
	
	override func closeButtonTapped() {
		guard let avatarCopy = view.viewWithTag(999) as? UIImageView, let headerView = self.profileHeaderView else {
			super.closeButtonTapped()
			return
		}
		let avatar = headerView.avatarImageView
		guard let avatarSuperview = avatar.superview else {
			super.closeButtonTapped()
			return
		}
		let avatarInitialFrame = avatarSuperview.convert(avatar.frame, to: view)
		UIView.animate(withDuration: 0.3, animations: {
			self.closeButton.alpha = 0
		})
		UIView.animate(withDuration: 0.5, animations: {
			self.overlayView.alpha = 0
			avatarCopy.frame = avatarInitialFrame
			avatarCopy.layer.cornerRadius = avatar.frame.height / 2
		}, completion: { _ in
			avatarCopy.removeFromSuperview()
			avatar.isHidden = false
		})
	}
	
	@objc func animateAvatarExpansion() {
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
}


extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Photos cell
		if section == 0 && isActiveProfile {
			return 1
		}
		if section == 0 && !isActiveProfile {
			return 0
		}
		// Posts
		return displayedPosts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.photos.rawValue, for: indexPath) as? PhotosTableViewCell else {
				fatalError("Could not dequeue PhotosTableViewCell")
			}
			cell.selectionStyle = .none
			return cell
		} else {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.base.rawValue, for: indexPath) as? PostCell else {
				fatalError("Could not dequeue CustomPostCell")
			}
			guard !displayedPosts.isEmpty else {
				return UITableViewCell()
			}
			cell.update(displayedPosts[indexPath.row])
			cell.selectionStyle = .none
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 0 {
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
		} else {
			guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderFooterReuseID.posts.rawValue) as? PostsTableHeaderView else {
				return nil
			}
			self.postsHeaderView = headerView
			return headerView
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if isActiveProfile {
			return section == 1 ? 30 : 300
		} else {
			return section == 1 ? 30 : 275
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			let galleryVC = PhotoGalleryViewController()
			navigationController?.pushViewController(galleryVC, animated: true)
		}
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return isActiveProfile ? (indexPath.section == 1) : false
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
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
