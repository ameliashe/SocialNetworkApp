//
//  FavoritesViewModel.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 3/4/25.
//

import Foundation
import CoreData
import UIKit

final class FavoritesViewModel {


	//MARK: Properties
	private(set) var posts: [Post] = []


	//MARK: Core Data
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "FavoritePost")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {

				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()


	//MARK: Data Fetching
	func fetchPosts() {
		let fetchRequest = FavoritePost.fetchRequest()
		let entities = (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
		let posts = entities.map(Post.init)

		persistentContainer.viewContext.perform { [weak self] in
			self?.posts = posts
		}
	}


	//MARK: Data Saving
	func savePost(_ post: Post) {
		if isPostSaved(post) {
			print("Post is already saved!")
			return
		}

		persistentContainer.performBackgroundTask { [weak self] backgroundContext in
			let postEntity = FavoritePost(context: backgroundContext)
			postEntity.authorID = post.authorID
			postEntity.postDescription = post.description
			postEntity.image = post.image
			postEntity.likes = Int64(post.likes)
			postEntity.views = Int64(post.views)
			postEntity.postTime = Int64(post.postTime)

			do {
				try backgroundContext.save()
				DispatchQueue.main.async {
					self?.fetchPosts()
				}
			} catch {
				print("Failed to save post: \(error)")
			}
		}
	}


	//MARK: Data Deletion
	func deletePost(_ post: FavoritePost) {

		persistentContainer.performBackgroundTask { [weak self] backgroundContext in
			guard let self  else {
				return
			}

			let postForDelete = backgroundContext.object(with: post.objectID)
			backgroundContext.delete(postForDelete)
			do {
				try self.persistentContainer.viewContext.save()
				self.fetchPosts()
			} catch {
				print("Failed to delete post: \(error)")
			}
		}
	}


	//MARK: Checking
	func isPostSaved(_ post: Post) -> Bool {
		return findPostEntity(post) != nil
	}

	private func findPostEntity(_ post: Post) -> FavoritePost? {
		let fetchRequest = FavoritePost.fetchRequest()
		fetchRequest.predicate = NSPredicate(
			format: "authorID == %@ AND postDescription == %@ AND image == %@",
			post.authorID, post.description, post.image
		)

		return (try? persistentContainer.viewContext.fetch(fetchRequest))?.first
	}
}

extension Post {
	init(entity: FavoritePost) {
		self.authorID = entity.authorID ?? ""
		self.description = entity.postDescription ?? ""
		self.image = entity.image ?? ""
		self.likes = Int(entity.likes)
		self.views = Int(entity.views)
		self.postTime = Int(entity.postTime)
	}
}
