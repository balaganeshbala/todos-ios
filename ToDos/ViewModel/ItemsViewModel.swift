//
//  ToDoItemModel.swift
//  BoilerPlateSUI
//
//  Created by Balaganesh on 24/11/22.
//

import Foundation
import FirebaseFirestore

@MainActor
class ItemsViewModel: ObservableObject {
    
    @Published var showConfetti = false
    @Published var todoItems: [TodoItem] = []
    @Published var isLoading = false
    
    let user: User
    
    init(user: User) {
        self.user = user
        Task {
            await self.fetchAllToDosFromFirestore()
        }
    }
    
    func updateTitle(newTitle: String, forItemAt index: Int) {
        let item = todoItems[index]
        let newItem = TodoItem(id: item.id, orderIndex: item.orderIndex, title: newTitle, at: item.at, isCompleted: item.isCompleted)
        todoItems[index] = newItem
        Task {
            await saveToDoToFirestore(todo: newItem)
        }
    }
    
    func updateCompletion(itemIndex: Int) {
        let item = todoItems[itemIndex]
        let newItem = TodoItem(id: item.id, orderIndex: item.orderIndex, title: item.title, at: item.at, isCompleted: !item.isCompleted)
        todoItems[itemIndex] = newItem
        Task {
            if newItem.isCompleted {
                showConfetti.toggle()
            }
            await saveToDoToFirestore(todo: newItem)
        }
    }
    
    func addItem(title: String, id: String = UUID().uuidString, isCompleted: Bool = false) {
        let newItem = TodoItem(id: id, orderIndex: todoItems.count, title: title, at: Date.now, isCompleted: isCompleted)
        todoItems.append(newItem)
        Task {
            await saveToDoToFirestore(todo: newItem)
        }
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
            Task {
                await deleteToDoFromFirestore(todo: objectToDelete)
                saveTodoListToFirestore()
            }
        }
    }

    func reorderItemsAndUpdateFirebase() {
        // Create a copy of the current order
        let originalOrder = todoItems.map { $0.id }
        
        // Sort the items: uncompleted first, completed last
        todoItems.sort { !$0.isCompleted && $1.isCompleted }
        
        // Check if the order has changed
        let newOrder = todoItems.map { $0.id }
        guard originalOrder != newOrder else {
            // If the order hasn't changed, skip Firebase updates
            return
        }
        
        // Update the orderIndex for each item
        for (index, item) in todoItems.enumerated() {
            todoItems[index] = TodoItem(
                id: item.id,
                orderIndex: index,
                title: item.title,
                at: item.at,
                isCompleted: item.isCompleted
            )
        }
        
        saveTodoListToFirestore()
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
        Task {
            for todo in self.todoItems {
                await saveToDoToFirestore(todo: todo)
            }
        }
    }
    
    func fetchAllToDosFromFirestore() async {
        self.isLoading = true
        let db = Firestore.firestore()
        do {
            let querySnapshot = try await db.collection("users")
                .document(user.id)
                .collection("todos")
                .order(by: "orderIndex", descending: false)
                .getDocuments()
            
            let documents = querySnapshot.documents
            var todoItems: [TodoItem] = []
            for document in documents {
                let data = document.data()
                do {
                    let todo = try TodoItem(fromFirestoreData: data)
                    todoItems.append(todo)
                } catch {
                    debugPrint("Error parsing todo with id \(document.documentID): \(error.localizedDescription)")
                }
            }
            debugPrint("Fetched \(todoItems.count) todos successfully!")
            self.todoItems = todoItems
            
        } catch {
            debugPrint("Error fetching todos: \(error.localizedDescription)")
        }
        self.isLoading = false
    }
    
    func saveToDoToFirestore(todo: TodoItem) async {
        let todoData = todo.toFirestoreData()
        let db = Firestore.firestore()
        do {
            let _ = try await db.collection("users")
                .document(user.id)
                .collection("todos")
                .document(todo.id).setData(todoData)
            
            debugPrint("Todo with id \(todo.id) saved successfully!")
        } catch {
            debugPrint("Error saving todo with id \(todo.id): \(error.localizedDescription)")
        }
    }
    
    func deleteToDoFromFirestore(todo: TodoItem) async {
        let db = Firestore.firestore()
        do {
            let _ = try await db.collection("users")
                .document(user.id).collection("todos").document(todo.id).delete()
            debugPrint("Todo with id \(todo.id) deleted successfully!")
        } catch {
            debugPrint("Error deleting todo: \(error.localizedDescription)")
        }
    }
}
