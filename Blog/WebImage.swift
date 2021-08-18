//
//  WebImage.swift
//  WebImage
//
//  Created by Владимир on 17.08.2021.
//

import SwiftUI

struct WebImage: View {
  var url: String
  let height = 250.0
  var body: some View {
    AsyncImage(url: URL(string: url)) { phase in
      if let image = phase.image {
        image
          .resizable()
          .aspectRatio(1, contentMode: .fill)
          .frame(width: UIScreen.main.bounds.width - 30, height: height)
          .cornerRadius(15)
      } else {
        if let error = phase.error {
          Text("Failed to load Image\n\(error.localizedDescription)")
        } else {
          ProgressView()
        }
      }
    }
    .frame(height: height)
  }
}

struct WebImage_Previews: PreviewProvider {
  static var previews: some View {
    WebImage(url: "https://funik.ru/wp-content/uploads/2018/10/0a37dbac85e134cfb3a5.jpg")
  }
}
