//
//  FirestorePostsService.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 7/3/25.
//

import Foundation
import FirebaseFirestore

class User: Codable {
	@DocumentID var id: String?
	var login: String
	var fullName: String
	var avatar: String
	var status: String
	var city: String
	var friends: [String]?
	var followers: [String]?
}

final class UsersStoreManager {
	let db = Firestore.firestore().collection("users")
	private let cache = NSCache<NSString, User>()
	
	func fetchAllUsers(completion: @escaping ([User]?) -> Void) {
		db.getDocuments { querySnapshot, error in
			let result = querySnapshot?.documents.compactMap { document in
				return try? document.data(as: User.self)
			}
			result?.forEach { self.cache.setObject($0, forKey: $0.login as NSString) }
			DispatchQueue.main.async {
				completion(result)
			}
		}
	}
	
	func fetchUser(byLogin login: String, completion: @escaping (User?) -> Void) {
		if let cached = cache.object(forKey: login as NSString) {
			DispatchQueue.main.async {
				completion(cached)
			}
			return
		}
		
		db.whereField("login", isEqualTo: login)
			.limit(to: 1)
			.getDocuments { querySnapshot, error in
				guard let document = querySnapshot?.documents.first,
					  let user = try? document.data(as: User.self) else {
					DispatchQueue.main.async {
						completion(nil)
					}
					return
				}
				self.cache.setObject(user, forKey: login as NSString)
				DispatchQueue.main.async {
					completion(user)
				}
			}
	}
	
	
	func save(user: User, completion: @escaping ((_ errorString: Error?) -> Void)) {
		_ = try? db.addDocument(from: user) { error in
			completion(error)
		}
	}
	
	func updateUser(_ user: User, completion: @escaping ((_ error: Error?) -> Void)) {
	let currentUserID = CurrentUserService().currentUserID

		guard let id = user.id else {
			completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is missing."]))
			return
		}

		do {
			try db.document(id).setData(from: user) { error in
				completion(error)
			}
		} catch {
			completion(error)
		}
	}
}
