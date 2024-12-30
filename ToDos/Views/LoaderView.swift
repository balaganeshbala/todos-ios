//
//  LoaderView.swift
//  ToDos
//
//  Created by Balaganesh on 24/12/24.
//

import SwiftUI

struct LoaderView: View {
    
    var text: String? = nil
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            if let text = text {
                Text(text)
                    .font(getFont(weight: .medium, size: UIFont.labelFontSize))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview(body: {
    VStack {
        LoaderView(text: "Please wait...")
            .background(Color("ThemeColor"))
            .frame(width: 150, height: 150)
            .cornerRadius(10)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray.opacity(0.5))
    .ignoresSafeArea()
})
