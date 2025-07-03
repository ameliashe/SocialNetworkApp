//
//  ImageLoader.swift
//  Navigation
//
//  Created by Amelia Romanova on 7/3/25.
//

import Foundation
import UIKit

final class ImageLoader {
	static let shared = ImageLoader()
	
	func load(from urlString: String, into imageView: UIImageView, placeholder: UIImage? = nil) {
		imageView.image = placeholder
		guard let url = URL(string: urlString) else { return }
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				print("ImageLoader error for \(urlString): \(error.localizedDescription)")
				return
			}
			
			if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
				print("ImageLoader error for \(urlString): status code \(http.statusCode)")
				return
			}
			
			guard let data = data, let image = UIImage(data: data) else {
				print("ImageLoader decoding error for \(urlString)")
				return
			}
			DispatchQueue.main.async {
				imageView.image = image
			}
		}
		task.resume()
	}
}
