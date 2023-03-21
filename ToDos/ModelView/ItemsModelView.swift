//
//  ToDoItemModel.swift
//  BoilerPlateSUI
//
//  Created by Balaganesh on 24/11/22.
//

import Foundation
import CoreData

class ItemsModelView: ObservableObject {
    
    let container: NSPersistentContainer
    
    private let todoItemsKey: String = "ToDoItems"
    
    @Published var todoItems: [ItemEntity] = []
    
    init() {
        container = PersistenceController.shared.container
        getItems()
    }
    
    func saveAndUpdateData() {
        do {
            try container.viewContext.save()
            getItems()
        } catch let error {
            print("Error saving: \(error)")
        }
    }
    
    func getItems() {
        let request = NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
        do {
            todoItems = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching: \(error)")
        }
    }
    
    func updateCompletion(item: ItemEntity) {
        item.setValue(!item.isCompleted, forKey: "isCompleted")
        saveAndUpdateData()
    }
    
    func addItem(title: String, id: String = UUID().uuidString, isCompleted: Bool = false) {
        let newItem = ItemEntity(context: container.viewContext)
        newItem.id = id
        newItem.title = title
        newItem.isCompleted = isCompleted
        saveAndUpdateData()
    }
    
    func getItem(itemIndex: IndexSet) -> ItemEntity? {
        var item: ItemEntity?
        itemIndex.forEach { index in
            item = self.todoItems[index]
        }
        return item
    }

    func deleteItem(itemIndex: IndexSet) {
        if let objectToDelete = getItem(itemIndex: itemIndex) {
            container.viewContext.delete(objectToDelete)
            self.saveAndUpdateData()
        }
    }
    
    func moveItem(itemIndex: IndexSet, offset: Int) {
        self.todoItems.move(fromOffsets: itemIndex, toOffset: offset)
        // TODO: Persist data
    }
}
