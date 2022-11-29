//
//  RegisterView.swift
//  SUIDemo
//
//  Created by Balaganesh on 28/11/22.
//

import SwiftUI

struct RegisterView: View {
    
    @Binding var showRegister: Bool
    
    @State var name: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .trailing, spacing: 10) {
                    
                    TextField("Name", text: $name)
                        .frame(height: 30)
                    
                    Seperator()
                        .padding(.bottom, 5)
                    
                    TextField("Email ID", text: $name)
                        .frame(height: 30)
                        .textInputAutocapitalization(.never)
                    
                    Seperator()
                        .padding(.bottom, 5)
                    
                    SecureField("Password", text: $password)
                        .frame(height: 30)
                    
                    Seperator()
                        .padding(.bottom, 5)
                    
                    SecureField("Confirm Password", text: $password)
                        .frame(height: 30)
                    
                    Seperator()
                        .padding(.bottom, 15)
                    
                    Button("Register") {
                        
                    }
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(5.0)
                    
                    
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Registration")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showRegister.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    
    @State static var showRegister = false
    
    static var previews: some View {
        RegisterView(showRegister: $showRegister)
    }
}
