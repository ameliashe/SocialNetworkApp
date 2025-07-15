//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 10/31/24.
//

import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView {
	
	//MARK: UI Elements
	private let backgroundContainerView = BackgroundContainerView()

	let avatarImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.isUserInteractionEnabled = true

		return imageView
	}()

	let fullNameLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 20, weight: .medium)
		label.textColor = ColorPalette.customTextColor
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	let statusLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12, weight: .light)
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	let cityLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12, weight: .medium)
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		label.attributedText = NSAttributedString(string: "")
		return label
	}()

	let postsView: CounterStackView = {
		let view = CounterStackView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	let friendsView: CounterStackView = {
		let view = CounterStackView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	let subscribersView: CounterStackView = {
		let view = CounterStackView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	lazy var countersStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [postsView, friendsView, subscribersView])

		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		stackView.spacing = 8
		stackView.translatesAutoresizingMaskIntoConstraints = false

		return stackView
	}()

	//MARK: Avatar closure
	var avatarTapped: (() -> Void)?

	//MARK: Initializers
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)

		addSubviews()
		setupConstraints()
		configureAvatarTap()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	//MARK: Layout methods
	override func layoutSubviews() {
		super.layoutSubviews()
		avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
	}

	private func addSubviews() {
		addSubview(backgroundContainerView)
		sendSubviewToBack(backgroundContainerView)
		addSubview(avatarImageView)
		addSubview(fullNameLabel)
		addSubview(statusLabel)
		addSubview(cityLabel)
		addSubview(countersStackView)
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			backgroundContainerView.topAnchor.constraint(equalTo: topAnchor, constant: -300),
			backgroundContainerView.bottomAnchor.constraint(equalTo: countersStackView.bottomAnchor, constant: 18),
			backgroundContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
			backgroundContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),

			avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
			avatarImageView.widthAnchor.constraint(equalToConstant: 120),
			avatarImageView.heightAnchor.constraint(equalToConstant: 120),

			fullNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
			fullNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10),
			fullNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			fullNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

			statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
			statusLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 8),
			statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

			cityLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
			cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -7),
			cityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			cityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

			countersStackView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 16),
			countersStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			countersStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
		])
	}

	//MARK: View Configuration
	func configure(with user: User, postsCount: Int?) {
		ImageLoader.shared.load(from: user.avatar, into: avatarImageView)
		fullNameLabel.text = user.fullName
		statusLabel.text = user.status
		cityLabel.text = user.city

		let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
		if let image = UIImage(systemName: "mappin.and.ellipse.circle", withConfiguration: config)?
			.withRenderingMode(.alwaysTemplate) {
			let renderer = UIGraphicsImageRenderer(size: image.size)
			let tintedImage = renderer.image { context in
				UIColor.lightGray.set()
				image.draw(in: CGRect(origin: .zero, size: image.size))
			}
			let attachment = NSTextAttachment()
			attachment.image = tintedImage
			attachment.bounds = CGRect(x: 0, y: -3, width: 14, height: 14)
			let attachmentString = NSAttributedString(attachment: attachment)
			let cityString = NSAttributedString(string: "  \(user.city)", attributes: [.foregroundColor: UIColor.lightGray])

			let fullString = NSMutableAttributedString()
			fullString.append(attachmentString)
			fullString.append(cityString)

			cityLabel.attributedText = fullString

			postsView.configure(count: postsCount ?? 0, title: NSLocalizedString("Posts", comment: "Posts counter title in profile"))
			friendsView.configure(count: user.friends?.count ?? 0, title: NSLocalizedString("Friends", comment: "Friends Counter Title in profile"))
			subscribersView.configure(count: user.followers?.count ?? 0, title: NSLocalizedString("Followers", comment: "Followers counter title in profile"))

		}
	}

	//MARK: Gesture recognition
	func configureAvatarTap() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTappedAction))
		avatarImageView.addGestureRecognizer(tapGesture)
	}

	@objc private func avatarTappedAction() {
		avatarTapped?()
	}
}
