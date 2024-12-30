//
//  ConfirmationAlert.swift
//  ToDos
//
//  Created by Balaganesh on 28/12/24.
//

import SwiftUI

struct ConfirmationAlert: View {
    let title: String
    let message: String
    let confirmActionTitle: String
    let cancelActionTitle: String
    let confirmAction: () -> Void
    @Binding var isPresented: Bool

    var body: some View {
        EmptyView() // Placeholder, as alert is a modifier
            .alert(title, isPresented: $isPresented) {
                Button(cancelActionTitle, role: .cancel) {
                    isPresented = false
                }
                Button(confirmActionTitle, role: .destructive) {
                    confirmAction()
                    isPresented = false
                }
            } message: {
                Text(message)
            }
    }
}
