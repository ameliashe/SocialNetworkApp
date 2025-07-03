//
//  PostsTableHeaderView.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 6/27/25.
//

import UIKit

class PostsTableHeaderView: UITableViewHeaderFooterView {

	let bgContainerView = BackgroundContainerView()
	
	let rectangleView: UIView = {
		let view = UIView()
		view.backgroundColor = ColorPalette.cardBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
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
		addSubview(rectangleView)
		addSubview(titleLabel)
	}
	
	func setupConstraints() {
		NSLayoutConstraint.activate([
			bgContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
			bgContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
			bgContainerView.topAnchor.constraint(equalTo: topAnchor),
			bgContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10),
			
			rectangleView.leadingAnchor.constraint(equalTo: leadingAnchor),
			rectangleView.trailingAnchor.constraint(equalTo: trailingAnchor),
			rectangleView.topAnchor.constraint(equalTo: bgContainerView.centerYAnchor),
			rectangleView.bottomAnchor.constraint(equalTo: bgContainerView.bottomAnchor),
			
			
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12)
			
		])
	}

}
