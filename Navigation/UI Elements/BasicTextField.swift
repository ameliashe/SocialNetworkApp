//
//  TextField.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 6/16/25.
//

import Foundation
import UIKit

class BasicTextField: UITextField {

	let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
	
	init() {
		super.init(frame: .zero)
		setupField()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override open func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}

	override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}

	override open func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}
	
	func setupField() {
		self.backgroundColor = ColorPalette.accentColor
		self.textColor = ColorPalette.customTextColor
		self.font = .systemFont(ofSize: 16)
		self.tintColor = UIColor(named: "AccentColor")
		self.isUserInteractionEnabled = true
	}
	
}

class SingleTextField: BasicTextField {
	override init() {
		super.init()
		customizeField()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func customizeField() {
		self.layer.cornerRadius = 12
		self.layer.borderWidth = 0.3
		self.layer.borderColor = UIColor.lightGray.cgColor
		self.layer.masksToBounds = true
	}
}
