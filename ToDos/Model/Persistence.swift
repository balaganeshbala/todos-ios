//
//  Persistence.swift
//  ToDos
//
//  Created by Balaganesh on 09/01/23.
//

import Foundation

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                print("Error loading data: \(error)")
            } else {
                print("Data successfully loaded.")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
