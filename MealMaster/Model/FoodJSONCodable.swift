// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let food = try? JSONDecoder().decode(Food.self, from: jsonData)

import Foundation

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
    
//    let links: Links?
    
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
    let enercKcal: Int?
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

//// MARK: - Links
//struct Links: Codable {
//    let next: Next?
//}
//
//// MARK: - Next
//struct Next: Codable {
//    let title: String?
//    let href: String?
//}

// MARK: - Parsed
struct Parsed: Codable {
    let food: ParsedFood?
}

// MARK: - ParsedFood
struct ParsedFood: Codable {
    let foodID, label, knownAs: String?
    let nutrients: Nutrients?
    let category: Category?
    let categoryLabel: CategoryLabel?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case foodID
        case label, knownAs, nutrients, category, categoryLabel, image
    }
}
