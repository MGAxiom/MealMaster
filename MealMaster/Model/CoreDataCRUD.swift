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
    
    func readFavouriteData(completion: @escaping (Result<[Favourite], CoreDataError>) -> Void){
        let request: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        request.relationshipKeyPathsForPrefetching = ["recipe"]
        do {
            let favouriteRecipes = try coreDataStack.viewContext.fetch(request)
            completion(.success(favouriteRecipes))
        } catch {
            completion(.failure(.failedAllFetch))
        }
    }
    
    func getMealsPlanned(completion: @escaping (Result<[PlanningDetails], CoreDataError>) -> Void) {
        let request: NSFetchRequest<PlanningDetails> = PlanningDetails.fetchRequest()
        
        do {
            let meals = try coreDataStack.viewContext.fetch(request)
            completion(.success(meals))
        } catch {
            completion(.failure(.failedAllFetch))
        }
    }
    
    func getRecipeDetails(id: String) -> Result<Recipe?, CoreDataError> {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "title == %@", id)
        
        do {
            return try .success(CoreDataStack.sharedInstance.viewContext.fetch(request).first)
        } catch {
            return .failure(.failedDetailsFetch)
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
//            alertUser(strMessage: "Error while trying to save recipe")
        }
    }
    
    func saveRecipe(recipe: Recipe, completion: @escaping (Result<CoreDataSuccess, CoreDataError>) -> Void) {
        // Insert the Recipe object into the CoreData context (had no context until now)
        if recipe.managedObjectContext == nil {
            coreDataStack.viewContext.insert(recipe)
        }
        let fav = Favourite(context: coreDataStack.viewContext)
        fav.recipe = recipe
        do {
            try coreDataStack.viewContext.save()
            completion(.success(.successfullSave))
        } catch {
            print(error)
            completion(.failure(.failedSave))
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
    
    func deleteFavourite(favorite: Favourite, completion: @escaping (Result<CoreDataSuccess, CoreDataError>) -> Void)  {
        coreDataStack.viewContext.delete(favorite)
        do {
            try coreDataStack.viewContext.save()
            completion(.success(.successfullDeletion))
        } catch {
            completion(.failure(.failedDeletion))
        }
    }
}

