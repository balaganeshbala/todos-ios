//
//  ItemModel.swift
//  BoilerPlateSUI
//
//  Created by Balaganesh on 25/11/22.
//

import Foundation

struct ItemModel: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let isCompleted: Bool
    
    init(id: String = UUID().uuidString, title: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
    
    func updateCompletion() -> ItemModel {
        return ItemModel(id: id, title: title, isCompleted: !isCompleted)
    }
    
    static func defaultItem() -> ItemModel {
        return ItemModel(id: "", title: "", isCompleted: false)
    }
}
