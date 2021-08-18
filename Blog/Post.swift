//
//  Post.swift
//  Post
//
//  Created by Владимир on 14.08.2021.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable {
  @DocumentID var id: String?
  @ServerTimestamp var createdTime: Timestamp?
  var title = ""
  var author = ""
  var postContent: [PostContent] = []
  var userId: String?
  var date: String {
    if let createdTime = createdTime {
      return "\(createdTime.dateValue().formatted(date: .numeric, time: .shortened))"
    } else {
      return ""
    }
  }
}

struct PostContent: Identifiable, Codable {
  var id = UUID().uuidString
  var value: String
  var type: PostType
  
  var height: CGFloat = 0
  var showImage = false
  var showDeleteAlert = false
  var frameHeight: CGFloat {
    height == 0 ? type.fontSize * 2 : height
  }
  enum CodingKeys: String, CodingKey {
    case value
    case type = "key"
  }
}

enum PostType: String, CaseIterable, Codable{
  case header = "Header"
  case subheading = "SubHeading"
  case paragraph = "Paragraph"
  case image = "Image"
  
  var fontSize: CGFloat {
    switch self {
    case .header:
      return 24
    case .subheading:
      return 22
    case .paragraph:
      return 18
    case .image:
      return 18
    }
  }
}
