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
    func readFavouriteData() throws -> [Favourite] {
        let request: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        request.relationshipKeyPathsForPrefetching = ["recipe"]
        return try coreDataStack.viewContext.fetch(request)
    }
    
    func readFoodData() throws -> [Food] {
        let request: NSFetchRequest<Food> = Food.fetchRequest()
        request.returnsObjectsAsFaults = false
        return try coreDataStack.viewContext.fetch(request)
    }
    
    func readFridgeDetails(name: String) throws -> [Food] {
        let request: NSFetchRequest<Food> = Food.fetchRequest()
        request.predicate = NSPredicate(format: "label == %@", name)
        return try coreDataStack.viewContext.fetch(request)
    }
    
    func getFridgeDetails(name: String) throws -> Food? {
        let request: NSFetchRequest<Food> = Food.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "label == %@", name)
        return try coreDataStack.viewContext.fetch(request).first
    }
    
    func getMealsPlanned() throws -> [PlanningDay] {
        let request: NSFetchRequest<PlanningDay> = PlanningDay.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \PlanningDay.date, ascending: true)
        ]
        return try coreDataStack.viewContext.fetch(request)
    }
    
    func getRecipe(id: String) throws -> Recipe? {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "title == %@", id)
        return try coreDataStack.viewContext.fetch(request).first
    }
    
    func get(date: String) throws -> PlanningDay? {
        let request: NSFetchRequest<PlanningDay> = PlanningDay.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "date == %@", date)
        return try coreDataStack.viewContext.fetch(request).first
    }
    
    func checkIfPlanned(date: String, meal: String) throws -> Bool {
        var tempDay: PlanningDay?
        tempDay = try get(date: date)
        if tempDay != nil {
            let request:  NSFetchRequest<PlanningMeal> = PlanningMeal.fetchRequest()
            request.predicate = NSPredicate(format: "meal == %@", meal)
            let count = try CoreDataStack.sharedInstance.viewContext.count(for: request)
            if count > 0 {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func getFoodIfInFridge(name: String, brand: String) throws -> Food? {
        let request:  NSFetchRequest<Food> = Food.fetchRequest()
        let predicateIsTitle = NSPredicate(format: "label == %@", name)
        let predicateIsBrand = NSPredicate(format: "brand == %@", brand)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateIsTitle, predicateIsBrand])
        if brand == "" {
            request.predicate = predicateIsTitle
        } else {
            request.predicate = andPredicate
        }
        return try coreDataStack.viewContext.fetch(request).first
    }
    
    func add(meal: String, date: String, for recipe: Recipe) throws {
        // Insert the Recipe object into the CoreData context (had no context until now)
        if recipe.managedObjectContext == nil {
            coreDataStack.viewContext.insert(recipe)
        }
        var day = try get(date: date)
        if day == nil {
            day = PlanningDay(context: coreDataStack.viewContext)
            day!.date = date
        }

        let planningMeal = PlanningMeal(context: coreDataStack.viewContext)
        planningMeal.meal = meal
        planningMeal.recipe = recipe
        planningMeal.day = day
        try coreDataStack.viewContext.save()
    }
    
    func delete(meal: PlanningMeal) throws {
        coreDataStack.viewContext.delete(meal)
        try coreDataStack.viewContext.save()
    }
    
    func save(recipe: Recipe) throws {
        // Insert the Recipe object into the CoreData context (had no context until now)
        if recipe.managedObjectContext == nil {
            coreDataStack.viewContext.insert(recipe)
        }
        let fav = Favourite(context: coreDataStack.viewContext)
        fav.recipe = recipe
        try coreDataStack.viewContext.save()
    }
    
    func delete(favorite: Favourite) throws  {
        coreDataStack.viewContext.delete(favorite)
        try coreDataStack.viewContext.save()
    }
    
    func save(food: Food, quantity: String) throws {
        // Insert the Recipe object into the CoreData context (had no context until now)
        coreDataStack.viewContext.insert(food)
        food.quantity = quantity
        try coreDataStack.viewContext.save()
    }
    
    func delete(food: Food) throws  {
        coreDataStack.viewContext.delete(food)
        try coreDataStack.viewContext.save()
    }
    
    func update(food name: String, with quantity: String) throws {
        let request: NSFetchRequest<Food> = Food.fetchRequest()
        request.predicate = NSPredicate(format: "label = %@", name as String)
        let result = try? coreDataStack.viewContext.fetch(request)
        let finalResult = result?.first
        finalResult?.quantity = quantity
        try coreDataStack.viewContext.save()
    }
     
}

