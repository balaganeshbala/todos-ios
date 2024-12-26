//
//  ToDoItemModel.swift
//  BoilerPlateSUI
//
//  Created by Balaganesh on 24/11/22.
//

import Foundation
import FirebaseFirestore

class ItemsViewModel: ObservableObject {
    
    @Published var todoItems: [TodoItem] = []
    @Published var isLoading = false
    
    init() {
        self.fetchAllToDosFromFirestore()
    }
    
    func updateTitle(newTitle: String, forItemAt index: Int) {
        let item = todoItems[index]
        let newItem = TodoItem(id: item.id, orderIndex: item.orderIndex, title: newTitle, at: item.at, isCompleted: item.isCompleted)
        todoItems[index] = newItem
        saveToDoToFirestore(todo: newItem)
    }
    
    func updateCompletion(itemIndex: Int) {
        let item = todoItems[itemIndex]
        let newItem = TodoItem(id: item.id, orderIndex: item.orderIndex, title: item.title, at: item.at, isCompleted: !item.isCompleted)
        todoItems[itemIndex] = newItem
        saveToDoToFirestore(todo: newItem)
    }
    
    func addItem(title: String, id: String = UUID().uuidString, isCompleted: Bool = false) {
        let newItem = TodoItem(id: id, orderIndex: todoItems.count, title: title, at: Date.now, isCompleted: isCompleted)
        todoItems.append(newItem)
        saveToDoToFirestore(todo: newItem)
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
            // Adjust the `orderIndex` of the remaining items
            todoItems.enumerated().forEach({ index, item in
                if item.orderIndex > objectToDelete.orderIndex {
                    todoItems[index] = TodoItem(id: item.id, orderIndex: item.orderIndex - 1, title: item.title, at: item.at, isCompleted: item.isCompleted)
                }
            })
            
            itemIndex.forEach { index in
                todoItems.remove(at: index)
            }
            deleteToDoFromFirestore(todo: objectToDelete)
            saveTodoListToFirestore()
        }
    }
    
    func moveItem(itemIndex: IndexSet, offset: Int) {
        var items = Array(todoItems)
        items.move(fromOffsets: itemIndex, toOffset: offset)

        for (newIndex, item) in items.enumerated() {
            todoItems[newIndex] = TodoItem(id: item.id, orderIndex: newIndex, title: item.title, at: item.at, isCompleted: item.isCompleted)
        }
        saveTodoListToFirestore()
    }
    
    func saveTodoListToFirestore() {
        for todo in self.todoItems {
            saveToDoToFirestore(todo: todo)
        }
    }
    
    func fetchAllToDosFromFirestore() {
        self.isLoading = true
        let db = Firestore.firestore()
        db.collection("todos")
            .order(by: "orderIndex", descending: false)
            .getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching todos: \(error.localizedDescription)")
            } else if let documents = querySnapshot?.documents {
                var todoItems: [TodoItem] = []
                for document in documents {
                    let data = document.data()
                    do {
                        let todo = try TodoItem(fromFirestoreData: data)
                        todoItems.append(todo)
                    } catch {
                        print("Error parsing todo with id \(document.documentID): \(error.localizedDescription)")
                    }
                }
                print("Fetched \(todoItems.count) todos successfully!")
                self.todoItems = todoItems
            } else {
                print("No todos found.")
            }
            
            self.isLoading = false
        }
    }
    
    func saveToDoToFirestore(todo: TodoItem) {
        let todoData = todo.toFirestoreData()
        let db = Firestore.firestore()
        db.collection("todos").document(todo.id).setData(todoData) { error in
            if let error = error {
                print("Error saving todo with id \(todo.id): \(error.localizedDescription)")
            } else {
                print("Todo with id \(todo.id) saved successfully!")
            }
        }
    }
    
    func deleteToDoFromFirestore(todo: TodoItem) {
        let db = Firestore.firestore()
        db.collection("todos").document(todo.id).delete { error in
            if let error = error {
                print("Error deleting todo: \(error.localizedDescription)")
            } else {
                print("Todo with id \(todo.id) deleted successfully!")
            }
        }
    }
}
