//
//  Allergies.swift
//  MealMaster
//
//  Created by Maxime Girard on 26/07/2023.
//

import Foundation
import UIKit

class Allergies {
    
    let allergiesValues: [String] = allergiesCases.allCases.map { "\($0.info.name)" }
    let allergiesImages: [String] = allergiesCases.allCases.map { "\($0.info.imageName)" }
    
    enum allergiesCases: CaseIterable {
        case alcoholCocktail, alcoholFree, celeryFree, crustaceanFree, dairyFree, DASH, eggFree, fishFree, fodmapFree, glutenFree, immunoSupportive, ketoFriendly, kidneyFriendly, kosher, lowFatAbs, lowPotassium, lowSugar, lupineFree, Mediterranean, molluskFree, mustardFree, noOilAdded, paleo, peanutFree, pescatarian, porkFree, redMeatFree, sesameFree, shellfishFree, soyFree, sugarConscious, sulfiteFree, treeNutFree, vegan, vegetarian, wheatFree
        
        var info: (name: String, imageName: String) {
            switch self {
            case .alcoholCocktail:
                return ("Alcohol-Cocktail", "star")
            case .alcoholFree:
                return ("Alcohol-Free", "star")
            case .celeryFree:
                return ("Celery-Free", "star")
            case .crustaceanFree:
                return ("Crustacean-Free", "star")
            case .dairyFree:
                return ("Dairy-Free", "icons8-lactose-free-24")
            case .DASH:
                return ("DASH", "star")
            case .eggFree:
                return ("Egg-Free", "star")
            case .fishFree:
                return ("Fish-Free", "star")
            case .fodmapFree:
                return ("Fodmap-Free", "star")
            case .glutenFree:
                return ("Gluten-Free", "icons8-no-gluten-24")
            case .immunoSupportive:
                return ("Immuno-Supportive", "star")
            case .ketoFriendly:
                return ("Keto-Friendly", "star")
            case .kidneyFriendly:
                return ("Kidney-Friendly", "star")
            case .kosher:
                return ("Kosher", "star")
            case .lowFatAbs:
                return ("Low-Fat-Abs", "star")
            case .lowPotassium:
                return ("Low-Potassium", "star")
            case .lowSugar:
                return ("Low-Sugar", "star")
            case .lupineFree:
                return ("Lupine-Free", "star")
            case .Mediterranean:
                return ("Mediterranean", "star")
            case .molluskFree:
                return ("Mollusk-Free", "star")
            case .mustardFree:
                return ("Mustard-Free", "star")
            case .noOilAdded:
                return ("No-Oil-Added", "star")
            case .paleo:
                return ("Paleo", "star")
            case .peanutFree:
                return ("Peanut-Free", "star")
            case .pescatarian:
                return ("Pescatarian", "star")
            case .porkFree:
                return ("Pork-Free", "icons8-no-pork-24")
            case .redMeatFree:
                return ("Red-Meat-Free", "star")
            case .sesameFree:
                return ("Sesame-Free", "star")
            case .shellfishFree:
                return ("Shellfish-Free", "star")
            case .soyFree:
                return ("Soy-Free", "star")
            case .sugarConscious:
                return ("Sugar-Conscious", "star")
            case .sulfiteFree:
                return ("Sulfite-Free", "star")
            case .treeNutFree:
                return ("Tree-Nut-Free", "star")
            case .vegan:
                return ("Vegan", "star")
            case .vegetarian:
                return ("Vegetarian", "star")
            case .wheatFree:
                return ("Wheat-Free", "star")
            }
        }
    }
    
//    let allergies = ["alcohol-cocktail","alcohol-free","celery-free","crustacean-free", "dairy-free", "DASH","egg-free", "fish-free", "fodmap-free", "gluten-free", "immuno-supportive", "keto-friendly", "kidney-friendly", "kosher", "low-fat-abs","low-potassium","low-sugar","lupine-free","Mediterranean","mollusk-free","mustard-free","no-oil-added","paleo","peanut-free","pescatarian","pork-free","red-meat-free","sesame-free","shellfish-free","soy-free","sugar-conscious","sulfite-free","tree-nut-free","vegan,vegetarian","wheat-free"]
    
    
}
