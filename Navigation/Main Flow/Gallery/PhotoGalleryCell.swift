//
//  PhotoGalleryCell.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 11/16/24.
//

import UIKit

class PhotoGalleryCell: UICollectionViewCell {

	//MARK: UI Elements
	let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()


	//MARK: Initializers
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubviews()
		configureConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	//MARK: Private Setup
	func addSubviews() {
		contentView.addSubview(imageView)
	}

	func configureConstraints() {
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
		])
	}
	

	//MARK: Cell Lifecycle
	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
	}


	//MARK: Configuration
	func update(_ imageName: UIImage) {
		imageView.image = imageName
	}

}
