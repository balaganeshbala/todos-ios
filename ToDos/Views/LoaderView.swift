//
//  LoaderView.swift
//  ToDos
//
//  Created by Balaganesh on 24/12/24.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        VStack() {
            Spacer()
            ProgressView() // Default SwiftUI loader
                .scaleEffect(1.5) // Enlarge the loader
            Text("Loading...")
                .font(getFont(weight: .medium, size: UIFont.labelFontSize))
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

#Preview(body: {
    LoaderView()
})
