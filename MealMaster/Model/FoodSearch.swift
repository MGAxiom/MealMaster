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

class FoodSearch {
    
    //MARK: - Properties
    
    private let session: AFSession
    static let shared = FoodSearch()
    
    //MARK: - Initializer
    
    init(session: AFSession = SearchSession()) {
        self.session = session
    }
    
    func foodAPI(userInput: String, callback: @escaping (Result<[Food], HTTPError>) -> Void ) {
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
            print(response.request?.url)
            switch response.result {
            case .success(let data):
                do {
                    let jsondata = try JSONDecoder().decode(FoodSearchResult.self, from: data!)
                    var foods: [Food] = []
                    for foodData in jsondata.foods {
                        // Create a Recipe object with no context (that will later be added to CoreDataStack.sharedInstance)
                        let food = Food(entity: entity!, insertInto: nil)
                        food.category = foodData.category
                        food.image = foodData.image
                        food.label = foodData.label
                        foods.append(food)
                    }
                    callback(.success(foods))
                } catch {
                    print(error)
                    callback(.failure(HTTPError.invalidJson))
                }
            case .failure(let error):
                print(AF.request.self)
                print(error)
                callback(.failure(HTTPError.commonError(error)))
            }
        }
    }
}

