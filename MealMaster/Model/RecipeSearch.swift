//
//  RecipeSearch.swift
//  MealMaster
//
//  Created by Maxime Girard on 17/07/2023.
//

import Foundation
import Alamofire
import AlamofireImage
import CoreData

//Class dedicated to the APICall used to search recipes, using the protocol AFSession
class RecipeSearch {
    
    //MARK: - Properties
    
    private let session: AFSession
    static let shared = RecipeSearch()
    
    //MARK: - Initializer
    
    init(session: AFSession = SearchSession()) {
        self.session = session
    }
    
    func recipeAPI(userInput: String, callback: @escaping (Result<[Recipe], Error>) -> Void ) {
        let url = "https://api.edamam.com/api/recipes/v2"
        let healthParameters = UserSettings.currentSettings.allergySet
        var parameters = [
            "q": [userInput],
            "app_key": ["c3401616aad93b34c82de83bbee1c2c7"],
            "app_id": ["4bd1f4d6"],
            "to": ["100"],
            "type": ["public"]
        ]
        if (!healthParameters.isEmpty) {
            parameters["health"] = Array(healthParameters)
        }
        
        // Description of the CoreData Entity
        let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: CoreDataStack.sharedInstance.viewContext)
        let encodingParameters = URLEncoding(destination: .methodDependent, arrayEncoding: .noBrackets, boolEncoding: .numeric)
        
        session.request(with: url, method: .get, parameters: parameters, encoding: encodingParameters) { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsondata = try JSONDecoder().decode(RecipeSearchResult.self, from: data!)
                    var recipes: [Recipe] = []
                    for recipeData in jsondata.recipes {
                        // Create a Recipe object with no context (that will later be added to CoreDataStack.sharedInstance)
                        let recipe = Recipe(entity: entity!, insertInto: nil)
                        recipe.title = recipeData.label
                        recipe.calories = recipeData.roundedCalories
                        recipe.time = recipeData.decodedTime
                        recipe.imageUrl = recipeData.image
                        recipe.ingredients = recipeData.ingredientLines!.joined(separator: ", ")
                        recipe.url = recipeData.url
                        recipe.foods = recipeData.decodedIngredientLines.joined(separator: ", ")
                        recipe.origin = recipeData.origins
                        recipes.append(recipe)
                    }
                    callback(.success(recipes))
                } catch {
                    callback(.failure(HTTPError.invalidJson))
                }
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    func randomRecipeAPI(callback: @escaping (Result<[Recipe], Error>) -> Void ) {
        let url = "https://api.edamam.com/api/recipes/v2"
        let healthParameters = UserSettings.currentSettings.allergySet
        var parameters = [
            "dishType": ["Main course"],
            "app_key": ["c3401616aad93b34c82de83bbee1c2c7"],
            "app_id": ["4bd1f4d6"],
            "random": ["true"],
            "type": ["public"]
        ]
        if (!healthParameters.isEmpty) {
            parameters["health"] = Array(healthParameters)
        }
        
        // Description of the CoreData Entity
        let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: CoreDataStack.sharedInstance.viewContext)
        let encodingParameters = URLEncoding(destination: .methodDependent, arrayEncoding: .noBrackets, boolEncoding: .numeric)
        
        session.request(with: url, method: .get, parameters: parameters, encoding: encodingParameters) { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsondata = try JSONDecoder().decode(RecipeSearchResult.self, from: data!)
                    var recipes: [Recipe] = []
                    for recipeData in jsondata.recipes {
                        // Create a Recipe object with no context (that will later be added to CoreDataStack.sharedInstance)
                        let recipe = Recipe(entity: entity!, insertInto: nil)
                        recipe.title = recipeData.label
                        recipe.calories = recipeData.roundedCalories
                        recipe.time = recipeData.decodedTime
                        recipe.imageUrl = recipeData.image
                        recipe.ingredients = recipeData.ingredientLines!.joined(separator: ", ")
                        recipe.url = recipeData.url
                        recipe.foods = recipeData.decodedIngredientLines.joined(separator: ", ")
                        recipe.origin = recipeData.origins
                        recipes.append(recipe)
                    }
                    callback(.success(recipes))
                } catch {
                    callback(.failure(HTTPError.invalidJson))
                }
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}

