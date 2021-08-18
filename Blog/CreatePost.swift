//
//  CreatePost.swift
//  CreatePost
//
//  Created by Владимир on 15.08.2021.
//

import SwiftUI

struct CreatePost: View {
  @EnvironmentObject var viewModel: BlogViewModel
  @State var post = Post()
  @FocusState var showKeyboard: Bool
  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack {
          TextField("Post Title", text: $post.title)
          TextField("Author", text: $post.author)
          
          rows
          
          menuButton
        }
        .padding()
      }
      .navigationTitle(post.title == "" ? "Post Title" : post.title)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          if !showKeyboard { cancelButton }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          if showKeyboard { doneButton }
          else { postButton }
        }
      }
    }
  }
  var rows: some View {
    ForEach($post.postContent) { $content in
      VStack {
        if content.type == .image {
          if content.showImage && content.value != "" {
            WebImage(url: content.value)
              .onTapGesture {
                withAnimation {
                  content.showImage = false
                }
              }
          } else {
            VStack {
              TextField("Image URL", text: $content.value, onCommit: {
                withAnimation {
                  content.showImage = true
                }
              })
              Divider()
            }
          }
        } else {
          TextView(text: $content.value, height: $content.height, fontSize: content.type.fontSize)
            .focused($showKeyboard)
            .frame(height: content.frameHeight)
            .background(
              Text(content.type.rawValue)
                .font(.system(size: content.type.fontSize))
                .foregroundColor(.gray)
                .opacity(content.value == "" ? 0.7 : 0)
                .padding(.leading, 5)
              , alignment: .leading
            )
        }
      } // VStack

      .frame(width: UIScreen.main.bounds.width - 30)
      .contentShape(Rectangle())
      .gesture(
        DragGesture()
          .onEnded { value in
            if -value.translation.width < (UIScreen.main.bounds.width / 2.5),
                !content.showDeleteAlert {
              content.showDeleteAlert = true
            }
          }
      )
      .alert("Sure to delete this content?", isPresented: $content.showDeleteAlert) {
        Button("Delete", role: .destructive) {
          if let index = post.postContent.firstIndex(where: { $0.id == content.id }) {
            let _ = withAnimation {
              post.postContent.remove(at: index)
            }
          }
        }
      }
    } // ForEach
  }
  var menuButton: some View {
    Menu {
      ForEach(PostType.allCases, id: \.rawValue) { type in
        Button(type.rawValue) {
          withAnimation {
            post.postContent.append(PostContent(value: "", type: type))
          }
        }
      }
    } label: {
      Image(systemName: "plus.circle.fill")
        .font(.title)
        .foregroundColor(.primary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  var cancelButton: some View {
    Button("Cancel") {
      viewModel.showCreatePost.toggle()
    }
  }
  var doneButton: some View {
    Button("Done") {
      showKeyboard.toggle()
    }
  }
  var postButton: some View {
    Button("Post") {
      viewModel.addPost(post)
    }
    .disabled(post.title == "" || post.author == "")
  }
}

struct CreatePost_Previews: PreviewProvider {
  static var previews: some View {
    CreatePost()
      .environmentObject(BlogViewModel())
  }
}
