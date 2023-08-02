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
    
//    func getAllRecipes(completion: ([Recipe]) -> Void) {
//        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
//
//        do {
//            let recipes = try coreDataStack.viewContext.fetch(request)
//            completion(recipes)
//        } catch {
//            alertUser(strMessage: "Error occured while trying to fetch all the recipes")
//        }
//    }
    
    func readFavouriteData(completion: ([Favourite]) -> Void){
        let request: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        request.relationshipKeyPathsForPrefetching = ["recipe"]
        do {
            let favouriteRecipes = try coreDataStack.viewContext.fetch(request)
            completion(favouriteRecipes)
        } catch {
            alertUser(strMessage: "Error occured while trying to fetch all the recipes")
        }
    }
    
    func getMealsPlanned(completion: ([PlanningDetails]) -> Void) {
        let request: NSFetchRequest<PlanningDetails> = PlanningDetails.fetchRequest()
        
        do {
            let meals = try coreDataStack.viewContext.fetch(request)
            completion(meals)
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
    
    func addRecipeToMeal(meal: String, date: String, for recipe: Recipe) {
        // Insert the Recipe object into the CoreData context (had no context until now)
        coreDataStack.viewContext.insert(recipe)
        let planning = PlanningDetails(context: coreDataStack.viewContext)
        planning.date = date
        planning.meal = meal
        do {
            try coreDataStack.viewContext.save()
        } catch {
            alertUser(strMessage: "Error while trying to save recipe")
        }
    }
    
    func saveRecipe(recipe: Recipe) {
        // Insert the Recipe object into the CoreData context (had no context until now)
        coreDataStack.viewContext.insert(recipe)
        let fav = Favourite(context: coreDataStack.viewContext)
        fav.recipe = recipe
        do {
            try coreDataStack.viewContext.save()
        } catch {
            alertUser(strMessage: "Error while trying to save recipe")
        }
    }
    
//    func checkIfItemExist(id: String) -> Bool {
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Recipe")
//        fetchRequest.fetchLimit = 1
//        fetchRequest.predicate = NSPredicate(format: "title == %@", id)
//        do {
//            let count = try coreDataStack.viewContext.count(for: fetchRequest)
//            if count > 0 {
//                return true
//            } else {
//                return false
//            }
//        } catch let error as NSError {
//            alertUser(strMessage: "An error occured while fetching the recipe.")
//            print("Could not fetch. \(error), \(error.userInfo)")
//            return false
//        }
//    }
    
    func deleteFavourite(favorite: Favourite) {
        coreDataStack.viewContext.delete(favorite)
        do {
            try coreDataStack.viewContext.save()
        } catch {
            alertUser(strMessage: "Error while trying to delete favourite")
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
