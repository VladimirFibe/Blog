//
//  PostRepository.swift
//  PostRepository
//
//  Created by Владимир on 17.08.2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class PostRepository: ObservableObject {
  let db = Firestore.firestore()
  
  @Published var posts = [Post]()
  
  init() {
    loadDate()
  }
  
  func loadDate() {
//    guard let userId = Auth.auth().currentUser?.uid else { return }
    db.collection("posts")
      .order(by: "createdTime")
//      .whereField("userId", isEqualTo: userId)
      .addSnapshotListener { querySnapShot, error in
        if let querySnapShot = querySnapShot {
          self.posts = querySnapShot.documents.compactMap({ try? $0.data(as: Post.self)
          })
        }
      }
  }
  
  func addPost(_ post: Post) {
    do {
      var addedPost = post
      addedPost.userId = Auth.auth().currentUser?.uid
      let _ = try db.collection("posts").addDocument(from: addedPost)
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  func removePost(_ post: Post) {
    if let postId = post.id {
      db.collection("posts").document(postId).delete { error in
        if let error = error {
          print(error.localizedDescription)
        }
      }
    }
  }
}

