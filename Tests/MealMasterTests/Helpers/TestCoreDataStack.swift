//
//  TestCoreDataStack.swift
//  MealMaster
//
//  Created by Maxime Girard on 08/09/2023.
//

import CoreData

final class TestCoreDataStack: CoreDataStack {
    let throwViewError: Bool = false
    
    // MARK: - Initializer
    
    convenience init() {
        self.init(modelName: "MealMaster")
    }
    
    override init(modelName: String) {
        super.init(modelName: modelName)
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.persistentContainer = container
    }
}

