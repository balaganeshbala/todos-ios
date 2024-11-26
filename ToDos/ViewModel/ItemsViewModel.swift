//
//  ToDoItemModel.swift
//  BoilerPlateSUI
//
//  Created by Balaganesh on 24/11/22.
//

import Foundation
import SwiftData

class ItemsViewModel {
    
    let modelContext: ModelContext
    var todoItems: [TodoItem]
    
    init(modelContext: ModelContext, todoItems: [TodoItem]) {
        self.modelContext = modelContext
        self.todoItems = todoItems
    }
    
    func updateCompletion(item: TodoItem) {
        item.isCompleted = !item.isCompleted
    }
    
    func addItem(title: String, id: String = UUID().uuidString, isCompleted: Bool = false) {
        let newItem = TodoItem(id: id, orderIndex: todoItems.count, title: title, at: Date.now, isCompleted: isCompleted)
        modelContext.insert(newItem)
    }
    
    func getItem(itemIndex: IndexSet) -> TodoItem? {
        var item: TodoItem?
        itemIndex.forEach { index in
            item = self.todoItems[index]
        }
        return item
    }

    func deleteItem(itemIndex: IndexSet) {
        if let objectToDelete = getItem(itemIndex: itemIndex) {
            modelContext.delete(objectToDelete)
        }
    }
    
    func moveItem(itemIndex: IndexSet, offset: Int) {
        
        var items = Array(todoItems)
        items.move(fromOffsets: itemIndex, toOffset: offset)

        for (newIndex, item) in items.enumerated() {
            item.orderIndex = newIndex
        }
    }
}
