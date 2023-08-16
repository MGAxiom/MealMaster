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
    
    func getMealsPlanned(completion: @escaping (Result<[PlanningDay], CoreDataError>) -> Void) {
        let request: NSFetchRequest<PlanningDay> = PlanningDay.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \PlanningDay.date, ascending: true)
        ]
        do {
            let days = try coreDataStack.viewContext.fetch(request)
            completion(.success(days))
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
    
    func getPlanningDay(date: String) -> PlanningDay? {
        let request: NSFetchRequest<PlanningDay> = PlanningDay.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "date == %@", date)
        do {
            return try CoreDataStack.sharedInstance.viewContext.fetch(request).first
        } catch {
            print("could not fetch day")
            return nil
        }
    }
    
    func addRecipeToMeal(meal: String, date: String, for recipe: Recipe, completion: @escaping (Result<CoreDataSuccess, CoreDataError>) -> Void) {
        // Insert the Recipe object into the CoreData context (had no context until now)
        if recipe.managedObjectContext == nil {
            coreDataStack.viewContext.insert(recipe)
        }
        var day = getPlanningDay(date: date)
        if day == nil {
            day = PlanningDay(context: coreDataStack.viewContext)
            day!.date = date
        }

        let planningMeal = PlanningMeal(context: coreDataStack.viewContext)
        planningMeal.meal = meal
        planningMeal.recipe = recipe
        planningMeal.day = day
        do {
            try coreDataStack.viewContext.save()
            completion(.success(.successfullPlanningSave))
        } catch {
            print(error)
            completion(.failure(.failedSave))
        }
    }
    
    func deleteRecipeFromMeal(meal: PlanningMeal, completion: @escaping (Result<CoreDataSuccess, CoreDataError>) -> Void) {
        coreDataStack.viewContext.delete(meal)
        do {
            try coreDataStack.viewContext.save()
            completion(.success(.successfullDeletion))
        } catch {
            print(error)
            completion(.failure(.failedDeletion))
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
            completion(.success(.successfullFavouriteSave))
        } catch {
            print(error)
            completion(.failure(.failedSave))
        }
    }
    
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

