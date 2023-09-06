//
//  RecipeJSONDeco.swift
//  MealMaster
//
//  Created by Maxime Girard on 17/07/2023.
//

import Foundation

// MARK: - RecipeSearchResult
struct RecipeSearchResult: Codable {
    let from, to, count: Int?
    let links: RecipeSearchResultLinks?
    let hits: [Hit]
    var recipes: [RecipeDecodable] {
        get {
            var res: [RecipeDecodable] = []
            for hit in hits {
                res.append(hit.recipe)
            }
            return res
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case from, to, count
        case links = "_links"
        case hits
    }
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: RecipeDecodable
    let links: HitLinks?

    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
    }
}

// MARK: - HitLinks
struct HitLinks: Codable {
    let linksSelf: Next?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - Next
struct Next: Codable {
    let href: String?
    let title: Title?
}

enum Title: String, Codable {
    case nextPage = "Next page"
    case titleSelf = "Self"
}

// MARK: - Recipe
struct RecipeDecodable: Codable {
    let uri: String?
    let label: String?
    let image: String?
    let images: Images?
    let source: String?
    let url: String?
    let shareAs: String?
    let yield: Double?
    let dietLabels, healthLabels: [String]?
    let cautions: [String]?
    let ingredientLines: [String]?
    var decodedIngredientLines: [String] {
        get {
            var foods: [String] = []
            guard let data = ingredients else {
                return foods
            }
            for ingredient in data {
                guard let food = ingredient.food else {
                    continue
                }
                foods.append(food)
            }
            return foods
        }
    }
    let ingredients: [Ingredient]?
    let calories: Double?
    let totalWeight: Double?
    let totalTime: Double?
    var decodedTime: String {
        get {
            let interval = (totalTime ?? 0) * 60
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .brief
            
            let formattedString = formatter.string(from: TimeInterval(interval))!
            return formattedString
        }
    }
    var roundedCalories: String {
        var cal = calories
        cal?.round()
        return String(format: "%.0f", cal ?? 0.0)
    }
    let cuisineType: [String]?
    var origins: String {
        get {
            let recipeOrigin: String = ""
            guard let data = cuisineType else {
                return recipeOrigin
            }
            return (data.joined(separator: ","))
        }
    }
    let mealType: [String]?
    let dishType: [String]?
}

// MARK: - Images
struct Images: Codable {
    let thumbnail, small, regular, large: Large?
    
    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
        case large = "LARGE"
    }
}

// MARK: - Large
struct Large: Codable {
    let url: String?
    let width, height: Int?
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let text: String?
    let quantity: Double?
    let measure: String?
    let food: String?
    let weight: Double?
    let foodCategory, foodID: String?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case text, quantity, measure, food, weight, foodCategory
        case foodID = "foodId"
        case image
    }
}

enum MealType: String, Codable {
    case brunch = "brunch"
    case lunchDinner = "lunch/dinner"
}

// MARK: - RecipeSearchResultLinks
struct RecipeSearchResultLinks: Codable {
    let next: Next?
}

