//
//  CustomPostCell.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 11/14/24.
//

import UIKit
import Foundation

class CustomPostCell: UITableViewCell {
	
	private var imageTask: URLSessionDataTask?
	
	let authorLabel = HeadlineLabel()
	
	let authorAvatarImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	let postDateLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12, weight: .regular)
		label.textColor = .systemGray
		label.layer.opacity = 0.5
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let descriptionLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .regular)
		label.textColor = .systemGray
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let likesLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .regular)
		label.textColor = ColorPalette.customTextColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let viewsLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .regular)
		label.textColor = ColorPalette.customTextColor
		label.layer.opacity = 0.2
		label.textAlignment = .right
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let attachedImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.backgroundColor = .black
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		addSubviews()
		setupConstraints()
		tuneView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		imageTask?.cancel()
		imageTask = nil
		authorAvatarImageView.image = UIImage(named: "avatar_placeholder")
		attachedImageView.image = nil
	}
	
	func addSubviews() {
		contentView.addSubview(authorAvatarImageView)
		contentView.addSubview(authorLabel)
		contentView.addSubview(descriptionLabel)
		contentView.addSubview(likesLabel)
		contentView.addSubview(viewsLabel)
		contentView.addSubview(attachedImageView)
		contentView.addSubview(postDateLabel)
	}
	
	func setupConstraints() {
		
		NSLayoutConstraint.activate([
			authorAvatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
			authorAvatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
			authorAvatarImageView.widthAnchor.constraint(equalToConstant: 40),
			authorAvatarImageView.heightAnchor.constraint(equalToConstant: 40),
			
			authorLabel.topAnchor.constraint(equalTo: authorAvatarImageView.topAnchor, constant: -2),
			authorLabel.leadingAnchor.constraint(equalTo: authorAvatarImageView.trailingAnchor, constant: 12),
			authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			
			postDateLabel.bottomAnchor.constraint(equalTo: authorAvatarImageView.bottomAnchor, constant: -4),
			postDateLabel.leadingAnchor.constraint(equalTo: authorAvatarImageView.trailingAnchor, constant: 12),
			postDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			
			attachedImageView.topAnchor.constraint(equalTo: authorAvatarImageView.bottomAnchor, constant: 6),
			attachedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			attachedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			attachedImageView.heightAnchor.constraint(equalTo: attachedImageView.widthAnchor, multiplier: 0.75),
			
			descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			descriptionLabel.topAnchor.constraint(equalTo: attachedImageView.bottomAnchor, constant: 16),
			
			likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
			likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
			
			viewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			viewsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
			viewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
			
		])
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		authorAvatarImageView.layer.cornerRadius = authorAvatarImageView.bounds.height / 2
	}
	
	func tuneView() {
		contentView.backgroundColor = ColorPalette.cardBackground
		accessoryType = .none
		authorAvatarImageView.layer.cornerRadius = authorAvatarImageView.frame.height / 2
	}
	
	func update(_ post: Post) {
		UsersStoreManager().fetchUser(byLogin: post.authorID) { [weak self] user in
			
			guard let self = self else { return }
			if let user = user {
				self.authorLabel.text = user.fullName
				ImageLoader.shared.load(
					from: user.avatar,
					into: self.authorAvatarImageView
				)
			} else {
				self.authorLabel.text = post.authorID
				self.authorAvatarImageView.image = UIImage(named: "avatar_placeholder")
			}
			
		}
		
		ImageLoader.shared.load(from: post.image, into: attachedImageView)
		
		descriptionLabel.text = post.description
		
		let date = Date(timeIntervalSince1970: TimeInterval(post.postTime))
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		postDateLabel.text = formatter.string(from: date)
		
		
		let heartAttachment = NSTextAttachment()
		heartAttachment.image = UIImage(systemName: "heart")
		heartAttachment.bounds = CGRect(x: 0, y: -2, width: 16, height: 14)
		let heartString = NSAttributedString(attachment: heartAttachment)
		let likesCount = NSAttributedString(string: " \(post.likes)")
		let likesAttributed = NSMutableAttributedString()
		likesAttributed.append(heartString)
		likesAttributed.append(likesCount)
		likesLabel.attributedText = likesAttributed
		
		let eyeAttachment = NSTextAttachment()
		eyeAttachment.image = UIImage(systemName: "eye")
		eyeAttachment.bounds = CGRect(x: 0, y: -2, width: 20, height: 14)
		let eyeString = NSAttributedString(attachment: eyeAttachment)
		let viewsCount = NSAttributedString(string: " \(post.views)")
		let viewsAttributed = NSMutableAttributedString()
		viewsAttributed.append(eyeString)
		viewsAttributed.append(viewsCount)
		viewsLabel.attributedText = viewsAttributed
	}
	
}
