//
//  CustomPostCell.swift
//  Navigation
//
//  Created by Amelia Romanova on 11/14/24.
//

import UIKit
import Foundation

class CustomPostCell: UITableViewCell {

	private var imageTask: URLSessionDataTask?

	let authorLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 20, weight: .bold)
		label.textColor = ColorPalette.customTextColor
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let authorAvatarImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	let postDateLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .regular)
		label.textColor = .systemGray
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
			
			authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
			authorLabel.leadingAnchor.constraint(equalTo: authorAvatarImageView.trailingAnchor, constant: 16),
			authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			
			postDateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 2),
			postDateLabel.leadingAnchor.constraint(equalTo: authorAvatarImageView.trailingAnchor, constant: 16),

			attachedImageView.topAnchor.constraint(equalTo: postDateLabel.bottomAnchor, constant: 12),
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

	func update(_ model: Post) {
		if let user = userList.first(where: { $0.login == model.authorID }) {
			authorLabel.text = user.fullName
			
			if let url = URL(string: user.avatar) {
				URLSession.shared.dataTask(with: url) { data, response, error in
					guard let data = data, let image = UIImage(data: data) else { return }
					DispatchQueue.main.async {
						self.authorAvatarImageView.image = image
					}
				}.resume()
				
			} else {
				authorAvatarImageView.image = UIImage(named: user.avatar)
			}
		} else {
			authorLabel.text = model.authorID
			authorAvatarImageView.image = nil
		}
		
		if let url = URL(string: model.image) {
			imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
				guard let self = self,
					  let data = data,
					  let image = UIImage(data: data) else { return }
				DispatchQueue.main.async { self.attachedImageView.image = image }
			}
			imageTask?.resume()
		} else {
			attachedImageView.image = nil
		}
		
		descriptionLabel.text = model.description
		
		let date = Date(timeIntervalSince1970: TimeInterval(model.postTime))
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		postDateLabel.text = formatter.string(from: date)
		
		
		let heartAttachment = NSTextAttachment()
		heartAttachment.image = UIImage(systemName: "heart")
		heartAttachment.bounds = CGRect(x: 0, y: -2, width: 16, height: 14)
		let heartString = NSAttributedString(attachment: heartAttachment)
		let likesCount = NSAttributedString(string: " \(model.likes)")
		let likesAttributed = NSMutableAttributedString()
		likesAttributed.append(heartString)
		likesAttributed.append(likesCount)
		likesLabel.attributedText = likesAttributed

		let eyeAttachment = NSTextAttachment()
		eyeAttachment.image = UIImage(systemName: "eye")
		eyeAttachment.bounds = CGRect(x: 0, y: -2, width: 20, height: 14)
		let eyeString = NSAttributedString(attachment: eyeAttachment)
		let viewsCount = NSAttributedString(string: " \(model.views)")
		let viewsAttributed = NSMutableAttributedString()
		viewsAttributed.append(eyeString)
		viewsAttributed.append(viewsCount)
		viewsLabel.attributedText = viewsAttributed
	}

}


@available(iOS 17, *)
#Preview {
	let thisView = CustomPostCell()
	thisView.update(posts[1])
	return thisView
}
