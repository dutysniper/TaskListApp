//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Константин Натаров on 19.05.2023.
//

import Foundation
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData(to taskList: inout [Task]) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            taskList = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateData() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            context.refresh(Task, mergeChanges: true)
        }
    }
}
