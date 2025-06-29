//
//  PostsTableHeaderView.swift
//  Navigation
//
//  Created by Amelia Romanova on 6/27/25.
//

import UIKit

class PostsTableHeaderView: UITableViewHeaderFooterView {

	let bgContainerView = BackgroundContainerView()
	
	var titleLabel: UILabel = {
		let label = UILabel()
		label.text = NSLocalizedString("Posts", comment: "Posts table header label")
		label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		label.textColor = ColorPalette.customTextColor
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)

		addSubviews()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func addSubviews() {
		addSubview(bgContainerView)
		addSubview(titleLabel)
	}
	
	func setupConstraints() {
		NSLayoutConstraint.activate([
			bgContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
			bgContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
			bgContainerView.topAnchor.constraint(equalTo: topAnchor),
			bgContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20),
			
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12)
			
		])
	}

}
