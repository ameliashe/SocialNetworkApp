//
//  TextFieldStackView.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 7/11/25.
//

import UIKit

final class TextFieldStackView: UIStackView {

	let label: HeadlineLabel
	let textField: SingleTextField

	func setupStack() {
		axis = .vertical
		spacing = 4
		addArrangedSubview(label)
		addArrangedSubview(textField)
		
		label.layer.opacity = 0.6
		
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
	}
	
	init(title: String) {
		self.label = HeadlineLabel(title: title)
		self.textField = SingleTextField()
		
		super.init(frame: .zero)
		setupStack()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


