//
//  LoginScreen.swift
//  ToDos
//
//  Created by Balaganesh on 26/12/24.
//

import SwiftUI

struct LoginScreen: View {
    
    @State private var email = ""
    @State private var password = ""
    
    @FocusState private var emailFocused: Bool
    @FocusState private var passwordFocused: Bool
    
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    DummyLoginImage()
                    
                    TextField("Email", text: $email)
                        .textFieldStyle()
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .focused($emailFocused)
                        .onTapGesture {
                            emailFocused = true
                        }
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle()
                        .focused($passwordFocused)
                        .onTapGesture {
                            passwordFocused = true
                        }
                    
                    Button(action: {
                        emailFocused = false
                        passwordFocused = false
                        Task {
                            await self.authViewModel.logIn(withEmail: email, password: password)
                        }
                    }, label: {
                        Text("Log In")
                            .primaryButton()
                    })
                    .disabled(!isValid())
                    
                    
                    NavigationLink() {
                        RegistrationScreen()
                            .onAppear {
                                clearTextFields()
                            }
                    } label: {
                        Text("Don't have an account? Register")
                            .secondaryButton()
                    }
                    
                    
                    if let error = authViewModel.loginError {
                        Text(error)
                            .font(getFont(weight: FontWeight.medium, size: UIFont.labelFontSize))
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                }
                .padding()
                
                if (authViewModel.isLogInLoading) {
                    VStack {
                        LoaderView(text: "Please wait...")
                            .background(Color("ThemeColor"))
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.5))
                    .ignoresSafeArea()
                }
            }
        }
    }
    
    private func clearTextFields() {
        email = ""
        password = ""
    }
    
    private func isValid() -> Bool {
        return !email.isEmpty && Helper.isValidEmail(email)
        && !password.isEmpty && password.count >= 6
    }
}

#Preview {
    LoginScreen()
        .environmentObject(AuthViewModel())
}
