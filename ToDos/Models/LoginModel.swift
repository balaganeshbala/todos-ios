//
//  LoginModel.swift
//  SUIDemo
//
//  Created by Balaganesh on 16/10/22.
//

import SwiftUI

struct User : Codable {
    let age: Int
    let _id: String
    let name: String
    let email: String
    let createdAt: String
    let updatedAt: String
}

struct LoggedInUser : Codable {
    let user: User
    let token: String
}

class LoginModel {
    
    func getLoggedInUserData() -> LoggedInUser? {
        do {
            var loggedInUser: LoggedInUser?
            
            if let storedData = UserDefaults.standard.value(forKey: "LoggedInUser") as? Data {
                loggedInUser = try JSONDecoder().decode(LoggedInUser.self, from: storedData)
            }
            
            return loggedInUser
        } catch {
            
        }
        
        return nil
    }
    
    func loginUser(emailId: String, password: String, completion: @escaping (LoggedInUser?) -> Void) {
        guard let url = URL(string: "https://api-nodejs-todolist.herokuapp.com/user/login") else {
            completion(nil)
            return
        }

        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"

        let json: [String: Any] = [ "email": emailId, "password": password ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        urlRequest.httpBody = jsonData
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completion(nil)
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else {
                    completion(nil)
                    return
                }
                do {
                    let loggedInUser = try JSONDecoder().decode(LoggedInUser.self, from: data)
                    UserDefaults.standard.set(data, forKey: "LoggedInUser")
                    completion(loggedInUser)
                } catch {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }

        dataTask.resume()
    }
}
