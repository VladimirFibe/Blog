//
//  BlogViewModel.swift
//  BlogViewModel
//
//  Created by Владимир on 14.08.2021.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI
import Combine

class BlogViewModel: ObservableObject {
  @Published var postRepository = PostRepository()
  @Published var posts: [Post]?
  @Published var showCreatePost = false
  @Published var isWriting = false
  private var cancellable = Set<AnyCancellable>()
  
  init() {
    postRepository.$posts
      .map { $0 }
      .assign(to: \.posts, on: self)
      .store(in: &cancellable)
  }
  
  func addPost(_ post: Post) {
    postRepository.addPost(post)
    showCreatePost = false
  }
  
  func removePost(_ post: Post) {
    postRepository.removePost(post)
  }
}
