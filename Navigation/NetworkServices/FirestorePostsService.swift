//
//  FirestorePostsService.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 7/3/25.
//

import Foundation
import FirebaseFirestore

public struct Post: Codable {
	@DocumentID var id: String?
	public let authorID: String
	public let description: String
	public let image: String
	public let likes: Int
	public let views: Int
	public let postTime: Int
}

final class PostsStoreManager {
	let db = Firestore.firestore().collection("posts")
	
	func fetchAllPosts(completion: @escaping ([Post]?) -> Void) {
		db.order(by: "postTime", descending: true).getDocuments { querySnapshot, error in
			let result = querySnapshot?.documents.compactMap { document in
				return try? document.data(as: Post.self)
			}
			
			DispatchQueue.main.async {
				completion(result)
			}
		}
	}
	
	
	func fetchPosts(byAuthor authorID: String, completion: @escaping (([Post]?) -> Void)) {
		db.whereField("authorID", isEqualTo: authorID).order(by: "postTime", descending: true).getDocuments { querySnapshot, error in
				let result = querySnapshot?.documents.compactMap { document in
					return try? document.data(as: Post.self)
				}
			DispatchQueue.main.async {
				completion(result)
			}
		}
	}
	
	func save(post: Post, completion: @escaping ((_ errorString: Error?) -> Void)) {
		_ = try? db.addDocument(from: post) { error in
			completion(error)
		}
	}
	
	func delete() {
		
	}
}
