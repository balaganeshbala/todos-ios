//
//  ToDosApp.swift
//  ToDos
//
//  Created by Balaganesh on 29/11/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct ToDosApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel())
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.isDarkTheme ? .dark : .light)
        }
    }
}

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if let user = authViewModel.user {
            HomeScreen(user: user)
        } else {
            LoginScreen()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
