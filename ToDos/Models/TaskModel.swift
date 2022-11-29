//
//  TaskModel.swift
//  SUIDemo
//
//  Created by Balaganesh on 28/11/22.
//

import Foundation

struct Task : Codable {
    let completed: Bool
    let _id: String
    let description: String
    let owner: String
    let createdAt: String
    let updatedAt: String
}

struct AddTaskResponse: Codable {
    let success: Bool
    let data: Task
}

struct Tasks: Codable {
    let count: Int
    let data: [Task]
}

class TaskModel {
    
    func getAllTasks() -> [Task] {
        
        do {
            var tasks: Tasks?
            
            if let storedData = UserDefaults.standard.value(forKey: "Tasks") as? Data {
                tasks = try JSONDecoder().decode(Tasks.self, from: storedData)
            }
            
            if let tasks = tasks {
                return tasks.data
            }
        } catch {
            
        }
        return []
    }
    
    
//    curl --location --request GET 'https://api-nodejs-todolist.herokuapp.com/task' \
//    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MzQ2ODJiZmY0MDI1NjAwMTdmNzE3M2QiLCJpYXQiOjE2Njk2Mzg3MjB9._P6h3tHSowQ_fe6OKIYAimwyyA0MnSh4e3zkT3cRShI' \
//    --header 'Content-Type: application/json'

    
    func getAllTasksFromRemote(token: String, completion: @escaping ([Task]) -> ()) {
        
        guard let url = URL(string: "https://api-nodejs-todolist.herokuapp.com/task") else {
            completion([])
            return
        }

        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        
        urlRequest.allHTTPHeaderFields = ["Authorization" : "Bearer \(token)"]
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completion([])
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else {
                    completion([])
                    return
                }
                
                do {
                    let tasks = try JSONDecoder().decode(Tasks.self, from: data)
                    UserDefaults.standard.set(data, forKey: "Tasks")
                    completion(tasks.data)
                } catch {
                    completion([])
                }
            } else {
                completion([])
            }
        }

        dataTask.resume()
    }
}
