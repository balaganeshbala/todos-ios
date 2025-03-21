//
//  AuthViewModel.swift
//  ToDos
//
//  Created by Balaganesh on 26/12/24.
//

@preconcurrency import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var loginError: String? = nil
    @Published var isLogInLoading: Bool = false
    
    @Published var signUpError: String? = nil
    @Published var isSignUpLoading: Bool = false {
        didSet {
            loaderText = TextConstants.PLEASE_WAIT
        }
    }
    
    @Published var loaderText: String = TextConstants.PLEASE_WAIT
    
    @Published var user: User? = nil
    
    init() {
        if let currentUser = Auth.auth().currentUser {
            setCurrentUserInfo(user: currentUser)
        }
    }
    
    func setCurrentUserInfo(user: FirebaseAuth.User) {
        if user.isEmailVerified,
           let name = user.displayName,
           let email = user.email {
            self.user = User(id: user.uid, name: name, email: email)
        } else {
            self.user = nil
        }
    }
    
    func logIn(withEmail email: String, password: String) async {
        self.isLogInLoading = true
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let currentUser = authResult.user
            if currentUser.isEmailVerified {
                setCurrentUserInfo(user: currentUser)
                self.loginError = nil
            } else {
                self.loginError = TextConstants.EMAIL_NOT_VERIFIED
            }
        } catch {
            debugPrint("Login error: \(error.localizedDescription)")
            self.loginError = TextConstants.INVALID_CREDENTIALS
        }
        isLogInLoading = false
    }
    
    func signUp(withName name: String, email: String, password: String) async {
        self.isSignUpLoading = true
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = name
            try await changeRequest.commitChanges()
            guard let user = Auth.auth().currentUser else {
                return
            }
            try await sendVerificationEmail(user: user)
            self.loaderText = TextConstants.VERIFY_YOUR_EMAIL
            let isVerified = await checkEmailVerification(user: user)
            if isVerified {
                setCurrentUserInfo(user: user)
                self.signUpError = nil
            } else {
                self.signUpError = TextConstants.EMAIL_NOT_VERIFIED
            }
        } catch {
            self.signUpError = TextConstants.REGISTRATION_ERROR
        }
        self.isSignUpLoading = false
    }
    
    func sendVerificationEmail(user: FirebaseAuth.User) async throws {
        if !user.isEmailVerified {
            try await user.sendEmailVerification()
        }
    }
    
    func checkEmailVerification(user: FirebaseAuth.User) async -> Bool {
        return await withCheckedContinuation { continuation in
            let timeout: TimeInterval = 2 * 60 // 2 minutes
            let startTime = Date()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                user.reload { error in
                    if let error = error {
                        debugPrint("Error reloading user: \(error.localizedDescription)")
                        timer.invalidate() // Stop timer on error
                        continuation.resume(returning: false)
                        return
                    }

                    if user.isEmailVerified {
                        debugPrint("✅ Email verified!")
                        timer.invalidate() // Stop checking
                        continuation.resume(returning: true)
                        return
                    }

                    if Date().timeIntervalSince(startTime) >= timeout {
                        debugPrint("❌ Timeout: Email not verified.")
                        timer.invalidate() // Stop checking after timeout
                        continuation.resume(returning: false)
                    }
                }
            }
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        self.user = nil
    }
}
