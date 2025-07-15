//
//  PhotoPreviewCollectionViewCell.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 11/16/24.
//

import UIKit

class PhotoPreviewCollectionViewCell: UICollectionViewCell {


	//MARK: UI Elements
	let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()


	//MARK: Configuration
	func update(_ imageName: UIImage) {
		imageView.image = imageName
		addSubviews()
		configure()
	}


	//MARK: Setup
	func addSubviews() {
		contentView.addSubview(imageView)
	}


	//MARK: Layout
	func configure() {
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}


	//MARK: Lifecycle
	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
	}
}
