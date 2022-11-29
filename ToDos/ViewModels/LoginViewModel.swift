//
//  LoginViewModel.swift
//  SUIDemo
//
//  Created by Balaganesh on 28/11/22.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    let loginModel = LoginModel()
    
    @Published var loggedInUser: LoggedInUser?
    @Published var isLoading: Bool = false
    @Published var errorOccured: Bool = false
    
    init() {
        self.loggedInUser = loginModel.getLoggedInUserData()
    }
    
    func loginUser(emailId: String, password: String) {
        isLoading = true
        loginModel.loginUser(emailId: emailId, password: password) { [unowned self] loggedInUser in
            DispatchQueue.main.async {
                self.isLoading = false
                if (loggedInUser != nil) {
                    self.loggedInUser = loggedInUser
                } else {
                    self.errorOccured = true
                }
            }
        }
    }
    
}
