//
//  FoodSearchTests.swift
//  MealMasterTests
//
//  Created by Maxime Girard on 08/09/2023.
//

import XCTest
import CoreData
@testable import MealMaster


final class CoreDataTests: XCTestCase {
    
    // MARK: - Properties
    
    var coreDataStack: TestCoreDataStack!
    var coreDataRepository: CoreDataCRUD!
    var favouriteDataTest: [Favourite] = []
    var recipes: [Recipe] = []
    var foods: [Food] = []
    var tempFoods: [Food] = []
    var foodies = [Food]()
    var mealmeal = [PlanningDay]()
    var meals: [PlanningDay] = []
    var recipe: Recipe?

    // MARK: - Test Life Cycle

    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack(modelName: "MealMaster")
        coreDataRepository = CoreDataCRUD(coreDataStack: coreDataStack)
        let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: CoreDataStack.sharedInstance.viewContext)
        recipe = Recipe(entity: entity!, insertInto: nil)
        recipe?.title = "Infused Butter"
        recipe?.calories = "1000"
        recipe?.time = "1h 30min"
        recipe?.imageUrl = "https://www.edamam.com/web-img/recipeimage.jpg"
        recipe?.ingredients = "butter"
        recipe?.url = "http://www.eating.com/recipes/infused-butter-recipe.html"
        recipe?.foods = "butter"
        recipe?.origin = "France"
        recipes.append(recipe!)
    }

    override func tearDown() {
        super.tearDown()
        guard let storeURL = coreDataStack.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url else {
            return
        }
        do {
            try self.coreDataStack.persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
        } catch {
            print(error)
        }
        coreDataRepository = nil
        coreDataStack = nil
        favouriteDataTest.removeAll()
        recipes.removeAll()
        foods.removeAll()
        tempFoods.removeAll()
    }
    
    // MARK: - Recipe CoreData Tests
    func testAddRecipeMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        do {
            try coreDataRepository.save(recipe: recipes.last!)
            favouriteDataTest = try coreDataRepository.readFavouriteData()
            XCTAssertTrue(favouriteDataTest.isEmpty == false)
            XCTAssertEqual(favouriteDataTest.last?.recipe?.title, "Infused Butter")
            XCTAssertEqual(favouriteDataTest.last?.recipe?.origin, "France")
            XCTAssertEqual(favouriteDataTest.last?.recipe?.time, "1h 30min")
            XCTAssertEqual(favouriteDataTest.last?.recipe?.url, "http://www.eating.com/recipes/infused-butter-recipe.html")
            XCTAssertEqual(favouriteDataTest.last?.recipe?.imageUrl, "https://www.edamam.com/web-img/recipeimage.jpg")
            XCTAssertEqual(favouriteDataTest.last?.recipe?.ingredients, "butter")
            XCTAssertEqual(favouriteDataTest.last?.recipe?.foods, "butter")
            XCTAssertEqual(favouriteDataTest.last?.recipe?.calories, "1000")
        } catch {
        }
    }


    func testFavouriteRecipesAreSaved_WhenAnEntityIsDeleted_ThenShouldBeCorrectlyDeleted() {
        do {
            try coreDataRepository.save(recipe: recipes.last!)
            try coreDataRepository.delete(favorite: (recipes.last?.favourite!)!)
            XCTAssertTrue(recipes.last?.favourite == nil)
        } catch {
        }
    }
    //
    func testFavouriteRecipesAreSaved_WhenTryingToFetchARecipe_ThenShouldGetTheRecipeSeaved() {
        do {
            let finalRecipe = try coreDataRepository.getRecipe(id: "Infused Butter")
            XCTAssertEqual(finalRecipe?.title, "Infused Butter")
        } catch {
        }
    }

    // MARK: - Food CoreData Tests
    func testAddFoodMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        let entity = NSEntityDescription.entity(forEntityName: "Food", in: CoreDataStack.sharedInstance.viewContext)
        let food = Food(entity: entity!, insertInto: nil)
        food.brand = "Président"
        food.category = "Generic Foods"
        food.image = "https://www.edamam.com/web-img/foodimage.jpg"
        food.label = "Butter"
        food.quantity = "1"
        foods.append(food)

        do {
            try coreDataRepository.save(food: food, quantity: food.quantity ?? "1")
            tempFoods = try coreDataRepository.readFoodData()
            XCTAssertTrue(tempFoods.isEmpty == false)
            XCTAssertTrue(tempFoods[0].brand == "Président")
            XCTAssertTrue(tempFoods[0].category == "Generic Foods")
            XCTAssertTrue(tempFoods[0].image == "https://www.edamam.com/web-img/foodimage.jpg")
            XCTAssertTrue(tempFoods[0].label == "Butter")
            XCTAssertTrue(tempFoods[0].quantity == "1")
            XCTAssertEqual(tempFoods[0].quantity, "1")
        } catch {
        }
    }

    func testAddFoodMethods_WhenAnEntityIsDeleted_ThenShouldBeCorrectlyDeleted() {
        let entity = NSEntityDescription.entity(forEntityName: "Food", in: CoreDataStack.sharedInstance.viewContext)
        let food = Food(entity: entity!, insertInto: nil)
        food.brand = "Président"
        food.category = "Generic Foods"
        food.image = "https://www.edamam.com/web-img/foodimage.jpg"
        food.label = "Butter"
        food.quantity = "1"
        foods.append(food)

        do {
            try coreDataRepository.save(food: food, quantity: "2")
            try coreDataRepository.delete(food: foods[0])
            XCTAssertTrue(foodies.isEmpty)
        } catch {
        }
    }

    func testUpdateFoodMethods_WhenAnEntityIsUpdated_ThenShouldBeCorrectlyUpdated() {
        do {
            try coreDataRepository.update(food: "Butter", with: "4")
            tempFoods = try coreDataRepository.readFoodData()
            XCTAssertTrue(tempFoods.isEmpty == false)
            XCTAssertTrue(tempFoods[0].label == "Butter")
            XCTAssertTrue(tempFoods[0].quantity == "4")
            try coreDataRepository.update(food: "Butter", with: "1")
        } catch {
        }
    }

    func testReadFridgeMethods_WhenTryingToReadEntity_ThenShouldGetCorrectEntity() {
        let entity = NSEntityDescription.entity(forEntityName: "Food", in: CoreDataStack.sharedInstance.viewContext)
        let food = Food(entity: entity!, insertInto: nil)
        food.brand = "Président"
        food.category = "Generic Foods"
        food.image = "https://www.edamam.com/web-img/foodimage.jpg"
        food.label = "Butter"
        food.quantity = "1"
        foods.append(food)

        do {
            try coreDataRepository.save(food: food, quantity: food.quantity ?? "1")
            tempFoods = try coreDataRepository.readFridgeDetails(name: "Butter")
            XCTAssertTrue(tempFoods.isEmpty == false)
            XCTAssertTrue(tempFoods[0].label == "Butter")
        } catch {
        }
    }

    func testGetFridgeMethods_WhenTryingToReadEntity_ThenShouldGetCorrectEntity() {
        let entity = NSEntityDescription.entity(forEntityName: "Food", in: CoreDataStack.sharedInstance.viewContext)
        let food = Food(entity: entity!, insertInto: nil)
        food.brand = "Président"
        food.category = "Generic Foods"
        food.image = "https://www.edamam.com/web-img/foodimage.jpg"
        food.label = "Butter"
        food.quantity = "1"
        foods.append(food)
        var tempFood: Food?
        do {
            try coreDataRepository.save(food: food, quantity: food.quantity ?? "1")
            tempFood = try coreDataRepository.getFridgeDetails(name: "Butter")
            XCTAssertTrue(tempFood?.label == "Butter")
        } catch {
        }
    }

    func testGetFoodInFridgeMethods_WhenTryingToGetEntity_ThenShouldGetCorrectEntity() {
        let entity = NSEntityDescription.entity(forEntityName: "Food", in: CoreDataStack.sharedInstance.viewContext)
        let food = Food(entity: entity!, insertInto: nil)
        food.brand = "Président"
        food.category = "Generic Foods"
        food.image = "https://www.edamam.com/web-img/foodimage.jpg"
        food.label = "Butter"
        food.quantity = "1"
        foods.append(food)
        var tempFood: Food?
        do {
            try coreDataRepository.save(food: food, quantity: food.quantity ?? "1")
            tempFood = try coreDataRepository.getFoodIfInFridge(name: "Butter", brand: "Président")
            XCTAssertEqual(tempFood?.brand, "Président")
            XCTAssertEqual(tempFood?.label, "Butter")
        } catch {
        }
    }

    func testGetFoodInFridgeMethods_WhenTryingToGetEntityWithoutBrand_ThenShouldGetCorrectEntity() {
        let entity = NSEntityDescription.entity(forEntityName: "Food", in: CoreDataStack.sharedInstance.viewContext)
        let food = Food(entity: entity!, insertInto: nil)
        food.brand = ""
        food.category = "Generic Foods"
        food.image = "https://www.edamam.com/web-img/foodimage.jpg"
        food.label = "Chicken"
        food.quantity = "1"
        foods.append(food)
        var tempFood: Food?
        do {
            try coreDataRepository.save(food: food, quantity: food.quantity ?? "1")
            tempFood = try coreDataRepository.getFoodIfInFridge(name: "Chicken", brand: "")
            XCTAssertEqual(tempFood?.brand, "")
            XCTAssertEqual(tempFood?.label, "Chicken")
        } catch {
        }
    }

    // MARK: - Meals CoreData Tests
    func testSaveMealMethods_WhenTryingToSaveEntity_ThenShouldSaveCorrectly() {
        do {
            try coreDataRepository.add(meal: "Breakfast", date: "Tue, Sep 12, 23", for: recipes.last!)
            meals = try coreDataRepository.getMealsPlanned()
            XCTAssertTrue(!meals.isEmpty)
            XCTAssertEqual(meals[0].date, "Mon, Sep 18, 23")
        } catch {
        }
    }

    func testCheckMealMethods_WhenTryingToReadEntity_ThenShouldReturnTrue() {
        let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: CoreDataStack.sharedInstance.viewContext)
        let recipe = Recipe(entity: entity!, insertInto: nil)
        recipe.title = "Infused Butter"
        recipe.calories = "1000"
        recipe.time = "1h 30min"
        recipe.imageUrl = "https://www.edamam.com/web-img/recipeimage.jpg"
        recipe.ingredients = "butter"
        recipe.url = "http://www.eating.com/recipes/infused-butter-recipe.html"
        recipe.foods = "butter"
        recipe.origin = "France"
        do {
            try coreDataRepository.add(meal: "Breakfast", date: "Tue, Sep 12, 23", for: recipes.last!)
            let check = try coreDataRepository.checkIfPlanned(date: "Tue, Sep 12, 23", meal: "Breakfast")
            XCTAssertEqual(check, true)
        } catch {
        }
    }
    
    func testCheckMealMethods_WhenTryingToReadUnplannedEntity_ThenShouldReturnFalse() {
        do {
            let check = try coreDataRepository.checkIfPlanned(date: "Tue, Sep 12, 23", meal: "Lunch")
            XCTAssertEqual(check, false)
        } catch {
        }
    }
    
    func testCheckMealMethods_WhenTryingToReadEntityWithoutDate_ThenShouldReturnFalse() {
        let string = String(describing: 12)
        do {
            let check = try coreDataRepository.checkIfPlanned(date: string, meal: "Lunch")
            XCTAssertEqual(check, false)
        } catch {
        }
    }
    
    func testCheckMealMethods_WhenTryingToDeleteEntity_ThenShouldDeleteEntityCorrectly() {
        do {
            let day = try coreDataRepository.get(date: "Tue, Sep 12, 23")
            let array = day?.meals?.allObjects as! [PlanningMeal?]
            for meals in array {
                try coreDataRepository.delete(meal: meals!)
            }
            let check = try coreDataRepository.checkIfPlanned(date: "Tue, Sep 12, 23", meal: "Lunch")
            XCTAssertEqual(check, false)
        } catch {
        }
    }
    
    //MARK: - UserSettings Test
    
    func testCreateUserSettingsMethods_WhenTryingToCreateEntity_ThenShouldCrateEntityCorrectly() {
        let firstus = UserSettings.currentSettings
        coreDataStack.viewContext.delete(firstus)
        do {
            try coreDataStack.viewContext.save()
        } catch {
        }
        let secondus = UserSettings.currentSettings
        XCTAssertNotEqual(firstus, secondus)
//        XCTAssertEqual(.has(allergy: allergy), false)
    }
    
    func testCreateUserSettingsMethods_WhenTryingToCreateEntity_ThenShouldCreateEntityCorrectly() {
        let allergy = Diet.Allergies.allCases
        for allergies in allergy {
            UserSettings.currentSettings.add(allergy: allergies)
            XCTAssertEqual(UserSettings.currentSettings.has(allergy: allergies), true)
        }
    }
    
    func testUpdatingUserSettingsMethods_WhenTryingToAddPhotoAndIndexAndNameToEntity_ThenShouldUpdateEntityCorrectly() {
        let photo = "photo.jpg"
        let name = "Maxime"
        let index = "1"
        do {
            try UserSettings.currentSettings.add(name: name)
            try UserSettings.currentSettings.add(photo: photo)
            try UserSettings.currentSettings.add(index: index)
        } catch {
        }
        
        XCTAssertEqual(UserSettings.currentSettings.index, "1")
        XCTAssertEqual(UserSettings.currentSettings.userphoto, "photo.jpg")
        XCTAssertEqual(UserSettings.currentSettings.username, "Maxime")
    }
    
    func testDeleteUserSettingsMethods_WhenTryingToDeleteFromEntity_ThenShouldUpdateEntityCorrectly() {
        let allergy = Diet.Allergies.celeryFree
        UserSettings.currentSettings.add(allergy: allergy)
        UserSettings.currentSettings.remove(allergy: allergy)
        XCTAssertEqual(UserSettings.currentSettings.has(allergy: allergy), false)
    }
    
    func testAddUserSettingsMethods_WhenTryingToAddDietToEntity_ThenShouldOnlyAddOneDietToEntityCorrectly() {
        let diet = Diet.vegan
        let realDiet = Diet.vegetarian
        UserSettings.currentSettings.add(diet: diet)
        UserSettings.currentSettings.add(diet: realDiet)
        XCTAssertEqual(UserSettings.currentSettings.allergySet.contains(realDiet.info.lowercased()), true)
        XCTAssertEqual(UserSettings.currentSettings.allergySet.contains(diet.info.lowercased()), false)
    }
    
    
}
