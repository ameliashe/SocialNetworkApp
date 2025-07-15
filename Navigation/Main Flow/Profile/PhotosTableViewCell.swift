//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 11/16/24.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
	
	private let backgroundContainerView = BackgroundContainerView()

	let spacing: CGFloat = 8
	let cornerRadius: CGFloat = 8

	let label: UILabel = {
		let label = UILabel()
		label.text = NSLocalizedString("Photos", comment: "Photos table view cell label")
		label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		label.textColor = ColorPalette.customTextColor
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let arrowButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
		button.tintColor = ColorPalette.customTextColor
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	let identifier: String = "PhotoPreviewCollectionViewCell"

	lazy var photosPreviewCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(PhotoPreviewCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .clear
		self.backgroundColor = .clear

		setupViews()
		setupConstraints()
		setupCollectionView()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	func setupViews() {
		contentView.addSubview(backgroundContainerView)
		contentView.addSubview(label)
		contentView.addSubview(arrowButton)
		contentView.addSubview(photosPreviewCollectionView)
	}

	func setupCollectionView() {
		photosPreviewCollectionView.delegate = self
		photosPreviewCollectionView.dataSource = self
	}

	func setupConstraints() {
		NSLayoutConstraint.activate([
			backgroundContainerView.topAnchor.constraint(equalTo: topAnchor, constant: -8),
			backgroundContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10),
			backgroundContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
			backgroundContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
			
			label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),

			arrowButton.centerYAnchor.constraint(equalTo: label.centerYAnchor),
			arrowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

			photosPreviewCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
			photosPreviewCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
			photosPreviewCollectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
			photosPreviewCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			photosPreviewCollectionView.heightAnchor.constraint(equalToConstant: (contentView.frame.width + 48)/4)
		])
	}
}

extension PhotosTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PhotoPreviewCollectionViewCell else {
			fatalError("could not dequeue cell")
		}
		cell.update(imageList[indexPath.row])
		cell.contentView.layer.cornerRadius = cornerRadius
		cell.contentView.layer.masksToBounds = true
		cell.contentView.clipsToBounds = true
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let size = (contentView.frame.width - 48)/4
		return CGSize(width: size, height: size)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return spacing
	}


}
