//
//  RegistrationScreen.swift
//  ToDos
//
//  Created by Balaganesh on 27/12/24.
//

import SwiftUI

struct RegistrationScreen: View {
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @FocusState private var nameFocused: Bool
    @FocusState private var emailFocused: Bool
    @FocusState private var passwordFocused: Bool
    @FocusState private var confirmPasswordFocused: Bool
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    DummyLoginImage()
                    
                    TextField("Name", text: $name)
                        .textFieldStyle()
                        .autocorrectionDisabled()
                        .autocapitalization(.words)
                        .focused($nameFocused)
                        .onTapGesture {
                            nameFocused = true
                        }
                    
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
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle()
                        .focused($confirmPasswordFocused)
                        .onTapGesture {
                            confirmPasswordFocused = true
                        }
                    
                    if let error = authViewModel.signUpError {
                        Text(error)
                            .font(getFont(weight: FontWeight.medium, size: UIFont.labelFontSize))
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        nameFocused = false
                        emailFocused = false
                        passwordFocused = false
                        confirmPasswordFocused = false
                        Task {
                            await self.authViewModel.signUp(withName: name, email: email, password: password)
                        }
                    }, label: {
                        Text("Sign Up")
                            .primaryButton()
                    })
                    .disabled(!isValid())
                    
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Already have an account? Log In")
                            .secondaryButton()
                    }
                    
                    Spacer()
                }
                .padding()
                
                if (authViewModel.isSignUpLoading) {
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
    
    private func isValid() -> Bool {
        return !name.isEmpty && name.count >= 4
        && !email.isEmpty && Helper.isValidEmail(email)
        && !password.isEmpty && password.count >= 6
        && !confirmPassword.isEmpty && confirmPassword.count >= 6
        && password == confirmPassword
    }
}

#Preview {
    RegistrationScreen()
        .environmentObject(AuthViewModel())
}
