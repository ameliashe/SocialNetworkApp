//
//  PhotoPreviewCollectionViewCell.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 11/16/24.
//

import UIKit

class PhotoPreviewCollectionViewCell: UICollectionViewCell {

	let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	func update(_ imageName: UIImage) {
		imageView.image = imageName
		addSubviews()
		configure()
	}

	func addSubviews() {
		contentView.addSubview(imageView)
	}

	func configure() {
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
	}
	

}
