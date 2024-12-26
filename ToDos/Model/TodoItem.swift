//
//  TodoItem.swift
//  ToDos
//
//  Created by Balaganesh on 26/11/24.
//

import Foundation
import FirebaseFirestore

struct TodoItem: Identifiable {
    var id: String
    var orderIndex: Int
    var title: String
    var at: Date
    var isCompleted: Bool
    
    init(id: String, orderIndex: Int, title: String, at: Date, isCompleted: Bool) {
        self.id = id
        self.orderIndex = orderIndex
        self.title = title
        self.at = at
        self.isCompleted = isCompleted
    }
    
    init(fromFirestoreData data: [String: Any]) throws {
            guard let id = data["id"] as? String,
                  let orderIndex = data["orderIndex"] as? Int,
                  let title = data["title"] as? String,
                  let at = data["at"] as? Timestamp,
                  let isCompleted = data["isCompleted"] as? Bool else {
                throw NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data structure"])
            }
        self.id = id
        self.orderIndex = orderIndex
        self.title = title
        self.at = at.dateValue()
        self.isCompleted = isCompleted
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "id": self.id,
            "orderIndex": self.orderIndex,
            "title": self.title,
            "at": self.at,
            "isCompleted": self.isCompleted
        ]
    }
}

extension TodoItem {
    static func dummyItem() -> TodoItem {
        TodoItem(id: UUID().uuidString, orderIndex: 0, title: "Dummy", at: .now, isCompleted: false)
    }
}
