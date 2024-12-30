//
//  Helper.swift
//  ToDos
//
//  Created by Balaganesh on 27/12/24.
//

import Foundation

class Helper {
    // Regular expression-based email validation
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
