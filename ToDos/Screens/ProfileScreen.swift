//
//  ProfileScreen.swift
//  ToDos
//
//  Created by Balaganesh on 27/12/24.
//

import SwiftUI

struct ProfileScreen: View {
    
    let user: User
    
    private var initialOfName: String {
        user.name.first.map { String($0).uppercased() } ?? "?"
    }
    
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showLogoutConfirmation = false
    
    var body: some View {
        VStack {
            List {
                Section {
                    HStack(spacing: 15) {
                        // Profile image with initial
                        Circle()
                            .fill(Color.accentColor.opacity(0.8))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Text(initialOfName)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(user.name)
                                .font(getFont(weight: FontWeight.bold, size: UIFont.labelFontSize))
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            Text(user.email)
                                .font(getFont(weight: FontWeight.medium, size: UIFont.labelFontSize))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        
                        Spacer() // Push content to the left
                    }
                    .padding(.vertical)
                }
                
                Section {
                    
                    Toggle("Dark Theme", isOn: $themeManager.isDarkTheme)
                    
                    Button {
                        
                    } label: {
                        Text("Delete Account")
                    }
                    
                    Button {
                        showLogoutConfirmation = true
                    } label: {
                        Text("Log Out")
                    }
                    .overlay(
                        ConfirmationAlert(
                            title: "Confirm Logout",
                            message: "Are you sure you want to log out?",
                            confirmActionTitle: "Log Out",
                            cancelActionTitle: "Cancel",
                            confirmAction: {
                                self.authViewModel.signOut()
                            },
                            isPresented: $showLogoutConfirmation
                        )
                    )
                }
            }
            
            Spacer()
        }
        .background(Color(.systemGray6))
    }
}

#Preview {
    ProfileScreen(user: User(id: "12345", name: "Sharmila Gomathi", email: "sharmila.test@gmail.com"))
}
