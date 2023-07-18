//
//  CoreDataStack.swift
//  MealMaster
//
//  Created by Maxime Girard on 17/07/2023.
//

import Foundation
import CoreData

open class CoreDataStack {
    
    // MARK: - Properties
    
    private let modelName: String
    
    public init(modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - Singleton
    
    static let sharedInstance = CoreDataStack(modelName: "MealMaster")
    
    // MARK: - Public
    
    var viewContext: NSManagedObjectContext {
        return CoreDataStack.sharedInstance.persistentContainer.viewContext
    }
    
    // MARK: - Private
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo) for: \(storeDescription.description)")
            }
        })
        return container
    }()
}

