//
//  CounterStackView.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 6/16/25.
//

import UIKit

final class CounterStackView: UIView {

	private let topLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: .medium)
		label.textColor = ColorPalette.customTextColor
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	private let bottomLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12, weight: .light)
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [topLabel, bottomLabel])
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.spacing = 4
		stackView.translatesAutoresizingMaskIntoConstraints = false

		return stackView
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}

	private func setupView() {
		addSubview(stackView)

		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}


	func configure(count: Int, title: String) {
		topLabel.text = "\(count)"
		bottomLabel.text = title
	}


}
