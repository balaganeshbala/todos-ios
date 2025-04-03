//
//  ThemeManager.swift
//  ToDos
//
//  Created by Balaganesh on 21/03/25.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @Published var isDarkTheme: Bool {
        didSet {
            UserDefaults.standard.set(isDarkTheme, forKey: "isDarkTheme")
        }
    }
    
    init() {
        self.isDarkTheme = UserDefaults.standard.bool(forKey: "isDarkTheme")
    }
}
