//
//  HomeScreen.swift
//  SUIDemo
//
//  Created by Balaganesh on 17/10/22.
//

import SwiftUI

struct HomeScreen: View {
    
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var taskModelView: TaskViewModel
    
    var body: some View {
        VStack {
//
//            Text("Age: \(network.loggedInUser?.user.age ?? 0)")
//            Text("Email ID: \(network.loggedInUser?.user.email ?? "")")
//
//            Text("Token: \(network.loggedInUser?.token ?? "")")
            List {
                ForEach(taskModelView.allTasks) { task in
                    Text(task.title)
                }
            }
            .listStyle(.grouped)
        }
        .navigationTitle("Tasks to Do")
        .onAppear() {
            if let token = loginViewModel.loggedInUser?.token {
                taskModelView.fetchAllTasksFromRemote(token: token)
            }
        }
    }
}

struct TasksView: View {
    
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(loginViewModel: LoginViewModel(), taskModelView: TaskViewModel())
    }
}
