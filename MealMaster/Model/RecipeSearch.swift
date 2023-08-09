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

class RecipeSearch {
    
    //MARK: - Properties
    
    private let session: AFSession
    static let shared = RecipeSearch()
    
    //MARK: - Initializer
    
    init(session: AFSession = SearchSession()) {
        self.session = session
    }
    
    func recipeAPI(userInput: String, healthCases: [String], callback: @escaping (Result<[Recipe], Error>) -> Void ) {
        let url = "https://api.edamam.com/api/recipes/v2"
        let healthParameters = UserSettings.currentSettings.allergySet
        let parameters = [
            "q": [userInput],
            "health": Array(healthParameters),
            "app_key": ["c3401616aad93b34c82de83bbee1c2c7"],
            "app_id": ["4bd1f4d6"],
            "to": ["100"],
            "type": ["public"]
        ]
        
        // Description of the CoreData Entity
        let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: CoreDataStack.sharedInstance.viewContext)
        let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(arrayEncoding: .noBrackets))
        let encodingdong = URLEncoding(destination: .methodDependent, arrayEncoding: .noBrackets, boolEncoding: .numeric)
        
        session.request(with: url, method: .get, parameters: parameters, encoding: encodingdong) { response in
            print(response.request?.url)
            switch response.result {
            case .success(let data):
                do {
                    let jsondata = try JSONDecoder().decode(RecipeSearchResult.self, from: data!)
                    var recipes: [Recipe] = []
                    for recipeData in jsondata.recipes {
                        // Create a Recipe object with no context (that will later be added to CoreDataStack.sharedInstance
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
                    print(error)
                    callback(.failure(HTTPError.invalidJson))
                }
            case .failure(let error):
                print(AF.request.self)
                print(error)
                callback(.failure(error))
            }
        }
    }
}

