//
//  CustomTextView.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 7/14/25.
//

import UIKit

final class CustomTextView: UITextView {

	private func configure() {
		self.backgroundColor = ColorPalette.accentColor
		self.textColor = ColorPalette.customTextColor
		self.font = .systemFont(ofSize: 16)
		self.isScrollEnabled = true
		self.alwaysBounceVertical = true
		self.textContainer.lineBreakMode = .byWordWrapping
		self.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
		self.layer.cornerRadius = 12
		self.layer.borderWidth = 0.3
		self.layer.borderColor = UIColor.lightGray.cgColor
	}

	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		configure()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}
}
