//
//  CustomViews.swift
//  SUIDemo
//
//  Created by Balaganesh on 28/11/22.
//

import SwiftUI

struct Seperator: View {
    var body: some View {
        Divider().background(.gray)
            .frame(height: 1, alignment: .center)
    }
}

struct LoaderView: View {
    var body: some View {
        VStack {
            
        }
        .overlay() {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2.0, anchor: .center)
                .tint(Color.pink)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(.gray)
        .opacity(0.5)
    }
}

struct CustomViews_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
