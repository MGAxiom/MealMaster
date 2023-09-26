//
//  FoodJSONDecodable.swift
//  MealMaster
//
//  Created by Maxime Girard on 17/07/2023.
//
import Foundation

//File used to read the response sent by the Edaman API when doing an APICall
// MARK: - Food
struct FoodSearchResult: Codable {
    let text: String?
    let parsed: [Parsed]?
    let hints: [Hint]
    var foods: [HintFood] {
        get {
            var res: [HintFood] = []
            for hint in hints {
                res.append(hint.food)
            }
            return res
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case text, parsed, hints
//        case links
    }
}

// MARK: - Hint
struct Hint: Codable {
    let food: HintFood
    let measures: [Measure]?
}

// MARK: - HintFood
struct HintFood: Codable {
    let foodID, label, knownAs: String?
    let nutrients: Nutrients?
    let category: String?
    let categoryLabel: String?
    let image: String?
    let brand, foodContentsLabel: String?
    let servingSizes: [ServingSize]?
    let servingsPerContainer: Double?
    
    enum CodingKeys: String, CodingKey {
        case foodID
        case label, knownAs, nutrients, category, categoryLabel, image, brand, foodContentsLabel, servingSizes, servingsPerContainer
    }
}

enum Category: String, Codable {
    case genericFoods = "Generic foods"
    case packagedFoods = "Packaged foods"
}

enum CategoryLabel: String, Codable {
    case food = "food"
}

// MARK: - Nutrients
struct Nutrients: Codable {
    let enercKcal: Double?
    let procnt, fat, chocdf, fibtg: Double?
    
    enum CodingKeys: String, CodingKey {
        case enercKcal
        case procnt
        case fat
        case chocdf
        case fibtg
    }
}

// MARK: - ServingSize
struct ServingSize: Codable {
    let uri: String?
    let label: String?
    let quantity: Double?
}

// MARK: - Measure
struct Measure: Codable {
    let uri: String?
    let label: String?
    let weight: Double?
}

// MARK: - Parsed
struct Parsed: Codable {
    let food: ParsedFood?
}

// MARK: - ParsedFood
struct ParsedFood: Codable {
    let foodID, label, knownAs: String?
    let nutrients: Nutrients?
    let category: Category?
    let categoryLabel: String?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case foodID
        case label, knownAs, nutrients, category, categoryLabel, image
    }
}
