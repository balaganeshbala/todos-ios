//
//  LoginScreen.swift
//  SUIDemo
//
//  Created by Balaganesh on 17/10/22.
//

import SwiftUI

struct LoginView: View {
    
    @State var emailId: String = ""
    @State var password: String = ""
    @State var showRegister: Bool = false
    
    @ObservedObject var loginViewModel: LoginViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                
                Image(systemName: "person")
                    .resizable()
                    .foregroundColor(.gray)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(50)
                
                HStack {
                    Image(systemName: "envelope")
                        .frame(width: 20)
                    
                    TextField("Email ID", text: $emailId)
                        .textFieldStyle(.plain)
                        .frame(height: 30)
                        .textInputAutocapitalization(.never)
                        .padding(.leading, 5.0)
                }
                
                Seperator()
                    .padding(.bottom, 10)
                
                HStack {
                    Image(systemName: "key")
                        .frame(width: 20)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.plain)
                        .frame(height: 30)
                        .padding(.leading, 5.0)
                }
                
                Seperator()
                    .padding(.bottom, 20)
                
                Button {
                    hideKeyboard()
                    loginViewModel.loginUser(emailId: emailId, password: password)
                } label: {
                    Text("Login")
                        .foregroundColor(.white)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(5.0)
                }
                
                Spacer()
                
                Button(action: {
                    hideKeyboard()
                    showRegister.toggle()
                }, label: {
                    Text("New User? Register")
                })
                
                .fullScreenCover(isPresented: $showRegister, content: {
                    RegisterView(showRegister: $showRegister)
                })
                
                .alert(isPresented: $loginViewModel.errorOccured) {
                            Alert(title: Text("Error"), message: Text("Something went wrong!"), dismissButton: .default(Text("Try Again")))
                        }
            }
            .padding()
            
            if (loginViewModel.isLoading) {
                LoaderView()
                    .ignoresSafeArea()
            }
        }
        .navigationTitle("Login")
    }
    
    func hideKeyboard() {
        
    }
}

struct LoginScreen_Previews: PreviewProvider {
    
    @State static var value = false
    
    static var previews: some View {
        LoginView(loginViewModel: LoginViewModel())
    }
}
