//
//  TodoItem.swift
//  ToDos
//
//  Created by Balaganesh Balaganesh on 26/11/24.
//

import Foundation
import SwiftData

@Model
final class TodoItem {
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
}
