//
//  NetworkService.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 2/1/25.
//

import Foundation

//enum RequestError: Error {
//	case errorAnswerCode
//	case dataIsNil
//	case error(Error)
//}
//
//class NetworkService {
//	static func request(from url: URL, completion: @escaping (Result<Data, RequestError>) -> Void) {
//
//		let session = URLSession.shared
//		let task = session.dataTask(with: url) { data, response, error in
//			if error != nil {
//				completion(.failure(.error(error!)))
//				return
//			}
//
//			if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
//				completion(.failure(.errorAnswerCode))
//				return
//			}
//
//			guard let data = data else {
//				completion(.failure(.dataIsNil))
//				return
//			}
//
//			completion(.success(data))
//		}
//		task.resume()
//	}
//}
