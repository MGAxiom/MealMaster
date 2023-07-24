//
//  CoreDataCRUD.swift
//  MealMaster
//
//  Created by Maxime Girard on 17/07/2023.
//

import Foundation
import CoreData
import UIKit

final class CoreDataCRUD {

    // MARK: - Properties
    
    private let coreDataStack: CoreDataStack
    
    // MARK: - Init
    
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Repository
    
    func getAllRecipes(completion: ([Recipe]) -> Void) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        do {
            let recipes = try coreDataStack.viewContext.fetch(request)
            completion(recipes)
        } catch {
            alertUser(strMessage: "Error occured while trying to fetch all the recipes")
        }
    }
    
    func getRecipeDetails(id: String) -> Recipe? {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "title == %@", id)
        
        do {
            return try CoreDataStack.sharedInstance.viewContext.fetch(request).first
        } catch {
            alertUser(strMessage: "Error trying to fetch recipe details.")
            return nil
        }
    }
    
    func saveRecipe(recipe: Recipe) {
        // Insert the Recipe object into the CoreData context (had no context until now)
        coreDataStack.viewContext.insert(recipe)
        do {
            try coreDataStack.viewContext.save()
        } catch {
            alertUser(strMessage: "Error while trying to save recipe")
        }
    }
    
    func checkIfItemExist(id: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Recipe")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "title == %@", id)
        do {
            let count = try coreDataStack.viewContext.count(for: fetchRequest)
            if count > 0 {
                return true
            } else {
                return false
            }
        } catch let error as NSError {
            alertUser(strMessage: "An error occured while fetching the recipe.")
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteRecipe(id: String) {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", id)
        let object = try! coreDataStack.viewContext.fetch(fetchRequest)
        for obj in object {
            coreDataStack.viewContext.delete(obj)
        }
    }
}

extension CoreDataCRUD {
    public func alertUser(strMessage: String) {
        let myAlert = UIAlertController(title: "Error !", message: strMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        UIApplication.shared.delegate?.window??.rootViewController?.present(myAlert, animated: true, completion: nil)
    }
}
