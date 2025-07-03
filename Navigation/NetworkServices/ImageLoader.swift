//
//  ImageLoader.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 7/3/25.
//

import Foundation
import UIKit

final class ImageLoader {
	private let cache = NSCache<NSString, UIImage>()
	static let shared = ImageLoader()
	
	func load(from urlString: String, into imageView: UIImageView) {
		let key = urlString as NSString
		if let cachedImage = cache.object(forKey: key) {
			imageView.image = cachedImage
			return
		}
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
			self.cache.setObject(image, forKey: key)
			DispatchQueue.main.async {
				imageView.image = image
			}
		}
		task.resume()
	}
}
