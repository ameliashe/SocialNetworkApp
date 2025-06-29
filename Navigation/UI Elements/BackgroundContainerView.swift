//
//  BackgroundContainerView.swift
//  Navigation
//
//  Created by Amelia Romanova on 6/26/25.
//

import UIKit

class BackgroundContainerView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView() {
		self.backgroundColor = ColorPalette.cardBackground
		self.translatesAutoresizingMaskIntoConstraints = false
		self.layer.cornerRadius = 24
	}
	
}
