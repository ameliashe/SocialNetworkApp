//
//  DarkMode.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 4/14/25.
//

import Foundation
import UIKit

extension UIColor {
	static func createColor (lightMode: UIColor, darkMode: UIColor) -> UIColor {
		guard #available(iOS 13.0, *) else {
			return lightMode
		}

		return UIColor { (traitCollection) -> UIColor in
			return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
		}
	}
}

struct ColorPalette {
	static let customBackground = UIColor.createColor(lightMode: .white, darkMode: .black)
	static let cardBackground = UIColor.createColor(lightMode: .white, darkMode: .systemGray6)
	static let customTextColor = UIColor.createColor(lightMode: .black, darkMode: .white)
	static let accentColor = UIColor.createColor(lightMode: .systemGray6, darkMode: .systemGray4)
}

