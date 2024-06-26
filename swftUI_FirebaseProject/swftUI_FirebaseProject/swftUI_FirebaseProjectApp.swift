//
//  swftUI_FirebaseProjectApp.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 18/06/24.
//

import SwiftUI
import FirebaseCore
import Firebase

@main
struct swftUI_FirebaseProjectApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
