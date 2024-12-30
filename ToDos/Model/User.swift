//
//  User.swift
//  ToDos
//
//  Created by Balaganesh on 27/12/24.
//

import Foundation

struct User {
    let id: String
    let name: String
    let email: String
}

extension User {
    static func dummyUser() -> User {
        User(id: "dummy_id", name: "Dummy User", email: "dummy.user@gmail.com")
    }
}
