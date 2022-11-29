//
//  TaskModelView.swift
//  SUIDemo
//
//  Created by Balaganesh on 28/11/22.
//

import Foundation

struct TaskLocal: Identifiable {
    let completed: Bool
    let id: String
    let title: String
}

class TaskViewModel: ObservableObject {
    
    let taskModel = TaskModel()
    
    @Published var allTasks: [TaskLocal] = []
    @Published var isLoading: Bool = false
    
    init() {
        self.allTasks = taskModel.getAllTasks().map { task in
            TaskLocal(completed: task.completed, id: task._id, title: task.description)
        }
    }
    
    func fetchAllTasksFromRemote(token: String) {
        self.isLoading = true
        self.taskModel.getAllTasksFromRemote(token: token) { allTasks in
            DispatchQueue.main.async {
                self.isLoading = false
                self.allTasks = allTasks.map { task in
                    TaskLocal(completed: task.completed, id: task._id, title: task.description)
                }
            }
        }
    }
    
    func addTask(title: String) {
        
    }
    
}
