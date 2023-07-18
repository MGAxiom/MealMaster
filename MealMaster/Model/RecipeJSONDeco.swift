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
    let yield: Int?
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
    let calories, totalCO2Emissions: Double?
    let co2EmissionsClass: String?
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
    let mealType: [MealType]?
    let dishType: [String]?
    let totalNutrients, totalDaily: [String: Total]?
    let digest: [Digest]?
}

//enum Caution: String, Codable {
//    case fodmap = "FODMAP"
//    case soy = "Soy"
//    case sulfites = "Sulfites"
//}

//enum Co2EmissionsClass: String, Codable {
//    case f = "F"
//    case g = "G"
//}

// MARK: - Digest
struct Digest: Codable {
    let label: Label?
    let tag: String?
    let schemaOrgTag: SchemaOrgTag?
    let total: Double?
    let hasRDI: Bool?
    let daily: Double?
    let unit: Unit?
    let sub: [Digest]?
}

enum Label: String, Codable {
    case calcium = "Calcium"
    case carbohydratesNet = "Carbohydrates (net)"
    case carbs = "Carbs"
    case carbsNet = "Carbs (net)"
    case cholesterol = "Cholesterol"
    case energy = "Energy"
    case fat = "Fat"
    case fiber = "Fiber"
    case folateEquivalentTotal = "Folate equivalent (total)"
    case folateFood = "Folate (food)"
    case folicAcid = "Folic acid"
    case iron = "Iron"
    case magnesium = "Magnesium"
    case monounsaturated = "Monounsaturated"
    case niacinB3 = "Niacin (B3)"
    case phosphorus = "Phosphorus"
    case polyunsaturated = "Polyunsaturated"
    case potassium = "Potassium"
    case protein = "Protein"
    case riboflavinB2 = "Riboflavin (B2)"
    case saturated = "Saturated"
    case sodium = "Sodium"
    case sugarAlcohols = "Sugar alcohols"
    case sugars = "Sugars"
    case sugarsAdded = "Sugars, added"
    case thiaminB1 = "Thiamin (B1)"
    case trans = "Trans"
    case vitaminA = "Vitamin A"
    case vitaminB12 = "Vitamin B12"
    case vitaminB6 = "Vitamin B6"
    case vitaminC = "Vitamin C"
    case vitaminD = "Vitamin D"
    case vitaminE = "Vitamin E"
    case vitaminK = "Vitamin K"
    case water = "Water"
    case zinc = "Zinc"
}

enum SchemaOrgTag: String, Codable {
    case carbohydrateContent = "carbohydrateContent"
    case cholesterolContent = "cholesterolContent"
    case fatContent = "fatContent"
    case fiberContent = "fiberContent"
    case proteinContent = "proteinContent"
    case saturatedFatContent = "saturatedFatContent"
    case sodiumContent = "sodiumContent"
    case sugarContent = "sugarContent"
    case transFatContent = "transFatContent"
}

enum Unit: String, Codable {
    case empty = "%"
    case g = "g"
    case kcal = "kcal"
    case mg = "mg"
    case µg = "µg"
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

// MARK: - Total
struct Total: Codable {
    let label: Label?
    let quantity: Double?
    let unit: Unit?
}

// MARK: - RecipeSearchResultLinks
struct RecipeSearchResultLinks: Codable {
    let next: Next?
}

