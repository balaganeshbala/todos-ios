//
//  AuthViewModel.swift
//  ToDos
//
//  Created by Balaganesh on 26/12/24.
//

import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var loginError: String? = nil
    @Published var isLogInLoading: Bool = false
    
    @Published var signUpError: String? = nil
    @Published var isSignUpLoading: Bool = false
    
    @Published var user: User? = nil
    
    init() {
        setCurrentUserInfo()
    }
    
    func setCurrentUserInfo() {
        if let currentUser = Auth.auth().currentUser,
           let name = currentUser.displayName,
           let email = currentUser.email {
            self.user = User(id: currentUser.uid, name: name, email: email)
        } else {
            self.user = nil
        }
    }
    
    func logIn(withEmail email: String, password: String) async {
        self.isLogInLoading = true
        do {
            let _ = try await Auth.auth().signIn(withEmail: email, password: password)
            setCurrentUserInfo()
            self.loginError = nil
        } catch {
            debugPrint("Login error: \(error.localizedDescription)")
            self.loginError = "Invalid Credentials!"
        }
        isLogInLoading = false
    }
    
    func signUp(withName name: String, email: String, password: String) async {
        self.isSignUpLoading = true
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = name
            let _ = try await changeRequest.commitChanges()
            setCurrentUserInfo()
            self.signUpError = nil
        } catch {
            self.signUpError = "Error in Registration!"
        }
        self.isSignUpLoading = false
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        setCurrentUserInfo()
    }
}
