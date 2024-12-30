//
//  CustomViews.swift
//  BoilerPlateSUI
//
//  Created by Balaganesh on 24/11/22.
//

import SwiftUI

enum FontWeight: String {
    case bold = "Bold"
    case light = "Light"
    case medium = "Medium"
    case regular = "Regular"
    case semibold = "SemiBold"
}

func getFont(weight: FontWeight, size: CGFloat) -> Font {
    Font.custom("Quicksand-" + weight.rawValue, size: size)
}

struct CustomTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(getFont(weight: .medium, size: UIFont.labelFontSize))
            .padding()
            .frame(height: 50.0)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.3).cornerRadius(10.0))
    }
}

struct CustomPrimaryButton: ViewModifier {
    
    private let themeColor: LinearGradient = LinearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    private let cornerRadius: CGFloat = 10.0
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .font(getFont(weight: .medium, size: UIFont.buttonFontSize))
            .padding(.vertical, 12.0)
            .background(Color.accentColor)
            .foregroundColor(Color.white)
            .cornerRadius(cornerRadius)
    }
}

struct CustomSecondaryButton: ViewModifier {
    
    private let themeColor: LinearGradient = LinearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    private let cornerRadius: CGFloat = 10.0
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .font(getFont(weight: .medium, size: UIFont.buttonFontSize))
            .padding(.vertical, 12.0)
            .background(Color.clear)
            .foregroundColor(Color.accentColor)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(themeColor, lineWidth: 1)
            )
    }
}

extension View {
    
    func primaryButton() -> some View {
        modifier(CustomPrimaryButton())
    }
    
    func secondaryButton() -> some View {
        modifier(CustomSecondaryButton())
    }
    
    func textFieldStyle() -> some View {
        modifier(CustomTextField())
    }
}

struct DummyLoginImage: View {
    
    private let size: CGFloat = 100.0
    
    var body: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .frame(width: size, height: size)
            .padding(20)
            .foregroundColor(.secondary)
    }
}

#Preview {
    DummyLoginImage()
}

struct PlusImageView: View {
    
    private let size: CGFloat = 60.0
    
    var body: some View {
        Image(systemName: "plus")
            .resizable()
            .foregroundColor(.white)
            .padding(20)
            .frame(width: size, height: size)
            .background(
                Color.pink.cornerRadius(size/2)
                    .shadow(radius: 2.0)
            )
    }
}

struct CheckmarkView: View {
    
    let isChecked : Bool
    
    var body: some View {
        VStack {
            if (isChecked) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .foregroundColor(Color.green)
            } else {
                Image(systemName: "circle")
                    .resizable()
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
            }
        }
        .frame(width: 20, height: 20)
        .background(
            Color.clear.cornerRadius(10.0)
        )
    }
}
