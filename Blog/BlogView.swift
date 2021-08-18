//
//  BlogView.swift
//  BlogView
//
//  Created by Владимир on 14.08.2021.
//

import SwiftUI
import Firebase

struct BlogView: View {
  @StateObject var viewModel = BlogViewModel()
  var body: some View {
    VStack {
      if let posts = viewModel.posts {
        if posts.isEmpty {
          startWritingView
        } else {
          List(posts) { post in
            postView(post)
              .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                  viewModel.removePost(post)
                } label: {
                  Image(systemName: "trash")
                }
              }
          }
        }
      } else {
        ProgressView()
      }
    }
    .navigationTitle("My Blog")
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .overlay(
      showCreatePostButton, alignment: .bottomTrailing
    )
    .fullScreenCover(isPresented: $viewModel.showCreatePost) {
      CreatePost()
        .overlay(showProgressWriting)
        .environmentObject(viewModel)
    }
    
  }
  @ViewBuilder
  func postView(_ post: Post) -> some View {
    NavigationLink {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .leading, spacing: 15) {
          Text("Written by: \(post.author)")
            .font(.callout)
            .foregroundColor(.gray)
          
          Text(post.date)
            .font(.caption.bold())
            .foregroundColor(.gray)
          
          ForEach(post.postContent) { content in
            if content.type == .image {
              WebImage(url: content.value)
            } else {
              Text(content.value)
                .font(.system(size: content.type.fontSize))
                .lineSpacing(10)
            }
          }
        }
        .padding()
      }
      .navigationTitle(post.title)
    } label: {
      VStack(alignment: .leading, spacing: 12) {
        Text(post.title).fontWeight(.bold)
        
        Text("Written by: \(post.author)")
          .font(.callout)
          .foregroundColor(.gray)
        
        Text(post.date)
          .font(.caption.bold())
          .foregroundColor(.gray)
      }
    }
    
  }
  var startWritingView: some View {
    (
      Text(Image(systemName: "rectangle.and.pencil.and.ellipsis"))
      +
      Text(" Start Writing Blog")
    )
      .font(.title)
      .fontWeight(.semibold)
      .foregroundColor(.primary)
  }
  var showCreatePostButton: some View {
    Button {
      viewModel.showCreatePost.toggle()
    } label: {
      Image(systemName: "plus")
        .font(.title2.bold())
        .foregroundColor(Color(.systemBackground))
        .padding()
        .background(Color(.label), in: Circle())
    }
    .padding()
    
  }
  var showProgressWriting: some View {
    ZStack {
      Color.primary.opacity(0.25)
        .ignoresSafeArea()
      
      ProgressView()
        .frame(width: 80, height: 80)
        .background(Color(.label), in: RoundedRectangle(cornerRadius: 15))
    }
    .opacity(viewModel.isWriting ? 1 : 0)
  }
}

struct BlogView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      BlogView()
    }
  }
}
