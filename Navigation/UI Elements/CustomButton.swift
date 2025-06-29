//
//  CustomButton.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 1/2/25.
//

import UIKit

final class CustomButton: UIButton {

	private var buttonAction: (() -> Void)?

	init(title: String, action: @escaping () -> Void) {
		super.init(frame: .zero)
		self.buttonAction = action
		setupButton(title: title)
		addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
	}

	required init?(coder: NSCoder) {
			super.init(coder: coder)
		}

	private func setupButton(title: String) {
		self.setTitle(title, for: .normal)
		self.setTitleColor(.white, for: .normal)
		self.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
		self.layer.masksToBounds = true
		self.layer.cornerRadius = 10
		self.translatesAutoresizingMaskIntoConstraints = false
	}

	@objc private func buttonTapped() {
		buttonAction?()
	}
}


final class CustomImageButton: UIButton {

	private var buttonAction: (() -> Void)?

	init(image: UIImage, action: @escaping () -> Void) {
		super.init(frame: .zero)
		self.buttonAction = action
		setupButton(image: image)
		addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
	}

	required init?(coder: NSCoder) {
			super.init(coder: coder)
		}

	private func setupButton(image: UIImage) {
		self.setImage(image, for: .normal)
		self.tintColor = .white
		self.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
		self.layer.masksToBounds = true
		self.layer.cornerRadius = 10
		self.translatesAutoresizingMaskIntoConstraints = false
	}

	@objc private func buttonTapped() {
		buttonAction?()
	}
}
