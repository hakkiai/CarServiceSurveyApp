//
//  PersistenceController.swift
//  SurveyApp
//
//  Created by Abhishek Tripathi Kuberji on 23/02/26.
//

import CoreData

/// A singleton controller responsible for setting up and managing the Core Data stack.
struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SurveyApp") //
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let url = storeDescription.url {
                print("📂 Core Data Database Path: \(url.path)")
            }
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
