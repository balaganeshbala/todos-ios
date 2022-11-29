//
//  LaunchScreen.swift
//  ToDos
//
//  Created by Balaganesh on 29/11/22.
//

import SwiftUI

struct LaunchScreen: View {
    
    let loginViewModel = LoginViewModel()
    let taskViewModel = TaskViewModel()
    
    var body: some View {
        NavigationView {
            if (loginViewModel.loggedInUser == nil) {
                LoginView(loginViewModel: loginViewModel)
            } else if (loginViewModel.loggedInUser != nil) {
                HomeScreen(loginViewModel: loginViewModel, taskModelView: taskViewModel)
            } else {
                Text("Loading...")
            }
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
