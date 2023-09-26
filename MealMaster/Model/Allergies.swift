//
//  Allergies.swift
//  MealMaster
//
//  Created by Maxime Girard on 26/07/2023.
//

import Foundation
import UIKit

//Enums dedicated to Allergies and Diet, used in UserSettings, and to make precise APICalls for RecipeSearch
enum Diet: CaseIterable {
    
    case omnivore
    case pescetarian
    case vegetarian
    case vegan
    
    var info: String {
        switch self {
        
        case .omnivore:
            return "Omnivore"
        case .pescetarian:
            return "Pescatarian"
        case .vegetarian:
            return "Vegetarian"
        case .vegan:
            return "Vegan"
        }
    }
    
    var apiInfo: String {
        switch self {
            
        case .omnivore:
            return ""
        case .pescetarian:
            return "pescatarian"
        case .vegetarian:
            return "vegetarian"
        case .vegan:
            return "vegan"
        }
    }
    
    enum Allergies: CaseIterable {
        case alcoholFree, celeryFree, crustaceanFree, dairyFree, eggFree, fishFree, fodmapFree, glutenFree, ketoFriendly, kidneyFriendly, kosher, lowSugar, lupineFree, molluskFree, mustardFree, noOilAdded, paleo, peanutFree, porkFree, redMeatFree, sesameFree, shellfishFree, soyFree, sugarConscious, sulfiteFree, wheatFree
        
        var info: (name: String, imageName: String) {
            switch self {
            case .alcoholFree:
                return ("Alcohol-Free", "icons8-no-alcohol-24")
            case .celeryFree:
                return ("Celery-Free", "icons8-no-celery-24")
            case .crustaceanFree:
                return ("Crustacean-Free", "noun-shrimp-free-allergy-5726680")
            case .dairyFree:
                return ("Dairy-Free", "icons8-lactose-free-24")
            case .eggFree:
                return ("Egg-Free", "icons8-no-eggs-24")
            case .fishFree:
                return ("Fish-Free", "icons8-no-fish-24")
            case .fodmapFree:
                return ("Fodmap-Free", "icons8-no-fructose-24")
            case .glutenFree:
                return ("Gluten-Free", "icons8-no-gluten-24")
            case .ketoFriendly:
                return ("Keto-Friendly", "noun-keto-2476023")
            case .kidneyFriendly:
                return ("Kidney-Friendly", "icons8-kidney-24")
            case .kosher:
                return ("Kosher", "icons8-kosher-food-24")
            case .lowSugar:
                return ("Low-Sugar", "icons8-spoon-of-sugar-24")
            case .lupineFree:
                return ("Lupine-Free", "noun-lupin-free-4576540")
            case .molluskFree:
                return ("Mollusk-Free", "icons8-nautilus-24")
            case .mustardFree:
                return ("Mustard-Free", "icons8-no-mustard-24")
            case .noOilAdded:
                return ("No-Oil-Added", "icons8-olive-oil-24")
            case .paleo:
                return ("Paleo", "icons8-paleo-diet-24")
            case .peanutFree:
                return ("Peanut-Free", "icons8-no-peanut-24")
            case .porkFree:
                return ("Pork-Free", "icons8-no-pork-24")
            case .redMeatFree:
                return ("Red-Meat-Free", "icons8-no-meat-24")
            case .sesameFree:
                return ("Sesame-Free", "icons8-no-sesame-24")
            case .shellfishFree:
                return ("Shellfish-Free", "icons8-no-shellfish-24")
            case .soyFree:
                return ("Soy-Free", "icons8-no-soy-24")
            case .sugarConscious:
                return ("Sugar-Conscious", "icons8-diabetic-food-24")
            case .sulfiteFree:
                return ("Sulfite-Free", "noun-no-sulfate-3801939")
            case .wheatFree:
                return ("Wheat-Free", "noun-wheat-free-3488856")
            }
        }
    }
}
