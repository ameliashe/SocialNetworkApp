//
//  HeadlineLabel.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 7/11/25.
//

import UIKit

final class HeadlineLabel: UILabel {
	
	init(title: String? = nil) {
		super.init(frame: .zero)
		setupLabel(title: title)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func setupLabel(title: String?) {
		self.text = title
		self.font = .systemFont(ofSize: 18, weight: .bold)
		self.textColor = ColorPalette.customTextColor
		self.textAlignment = .left
		self.translatesAutoresizingMaskIntoConstraints = false
	}
	
}
