//
//  Post.swift
//  Post
//
//  Created by Владимир on 14.08.2021.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase

struct Post: Identifiable, Codable{
  @DocumentID var id: String?
  var title: String
  var date: Timestamp
  var author: String
  var postContent: [PostContent]
  
  enum CodingKeys: String, CodingKey{
    case id
    case title
    case date
    case author
    case postContent
  }
}

struct PostContent: Identifiable, Codable{
  var id = UUID().uuidString
  var value: String
  var type: PostType
  
  var height: CGFloat = 0
  var showImage: Bool = false
  var showDeleteAlert: Bool = false
  
  enum CodingKeys: String, CodingKey{
    case type = "key"
    case value
  }
}

enum PostType: String, CaseIterable, Codable{
  
  case Header = "Header"
  case SubHeading = "SubHeading"
  case Paragraph = "Paragraph"
  case Image = "Image"
}
