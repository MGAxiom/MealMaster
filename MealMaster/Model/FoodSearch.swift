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
    
    func foodAPI(userInput: String, callback: @escaping (Result<[Food], Error>) -> Void ) {
        let url = "https://api.edamam.com/api/food-database/v2/parser"
        var parameters = [
            "ingr": [userInput],
            "app_key": ["b906cefffc4ebe498b42d62c5f9e556d"],
            "app_id": ["8798566c"],
            "nutrition-type": ["cooking"]
        ]
        // Description of the CoreData Entity
        let entity = NSEntityDescription.entity(forEntityName: "Food", in: CoreDataStack.sharedInstance.viewContext)
        let encodingParameters = URLEncoding(destination: .methodDependent, arrayEncoding: .noBrackets, boolEncoding: .numeric)
        
        session.request(with: url, method: .get, parameters: parameters, encoding: encodingParameters) { response in
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
                        food.brand = foodData.brand
                        foods.append(food)
                    }
                    callback(.success(foods))
                } catch {
                    callback(.failure(HTTPError.invalidJson))
                }
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}

