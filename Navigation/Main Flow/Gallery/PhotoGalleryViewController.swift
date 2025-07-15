//
//  PhotoGalleryViewController.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 11/16/24.
//

import UIKit

  
//MARK: UI Elements
class PhotoGalleryViewController: UIViewController {

	let identifier: String = "PhotoGalleryCell"
	let itemsPerRow: CGFloat = 3
	let spacing: CGFloat = 8
	let sectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = ColorPalette.customBackground
		collectionView.register(PhotoGalleryCell.self, forCellWithReuseIdentifier: identifier)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()

  
//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = NSLocalizedString("Photo Gallery", comment: "Photo gallery VC title")
		addSubviews()
		addConstraints()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = false
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.navigationBar.isHidden = true
	}

  
//MARK: Setup
	func addSubviews() {
		view.addSubview(collectionView)
		collectionView.delegate = self
		collectionView.dataSource = self

	}

  
//MARK: Layout
	func addConstraints() {
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}

extension PhotoGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return imageList.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PhotoGalleryCell else {
			fatalError("could not dequeue cell")
		}
		
		cell.update(imageList[indexPath.row])
		cell.contentView.layer.masksToBounds = true
		cell.contentView.clipsToBounds = true
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let size = (view.frame.width-32)/3
		return CGSize(width: size, height: size)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return spacing
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return spacing
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return sectionInsets
	}

}


