//
//  ToDoItemModel.swift
//  BoilerPlateSUI
//
//  Created by Balaganesh on 24/11/22.
//

import Foundation

class ItemsModelView: ObservableObject {
    
    private let todoItemsKey: String = "ToDoItems"
    
    @Published var todoItems: [ItemModel] = [] {
        didSet {
            do {
                let encodedItems = try? JSONEncoder().encode(todoItems)
                UserDefaults.standard.set(encodedItems, forKey: todoItemsKey)
            }
        }
    }
    
    init() {
        getItems()
    }
    
    func getItems() {
        if let encodedItems = UserDefaults.standard.value(forKey: todoItemsKey) as? Data {
            do {
                self.todoItems = try! JSONDecoder().decode([ItemModel].self, from: encodedItems)
            }
        }
    }
    
    func updateCompletion(item: ItemModel) {
        if let index = self.todoItems.firstIndex(where: { existingItem in
            existingItem.id == item.id
        }) {
            todoItems[index] = item.updateCompletion()
        }
    }
    
    func updateItem(item: ItemModel) {
        if let index = self.todoItems.firstIndex(where: { existingItem in
            existingItem.id == item.id
        }) {
            todoItems[index] = item
        }
    }
    
    func addItem(title: String) {
        self.todoItems.append(ItemModel(title: title, isCompleted: false))
    }

    func deleteItem(itemIndex: IndexSet) {
        self.todoItems.remove(atOffsets: itemIndex)
    }
    
    func moveItem(itemIndex: IndexSet, offset: Int) {
        self.todoItems.move(fromOffsets: itemIndex, toOffset: offset)
    }
}
