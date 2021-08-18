//
//  BlogApp.swift
//  Blog
//
//  Created by Владимир on 14.08.2021.
//

import SwiftUI
import Firebase
@main
struct BlogApp: App {
  init() {
    FirebaseApp.configure()
    if Auth.auth().currentUser == nil {
      Auth.auth().signInAnonymously()
    }
  }
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
