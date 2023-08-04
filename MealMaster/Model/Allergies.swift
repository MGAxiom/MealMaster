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
    
//    let allergies = ["alcohol-cocktail","alcohol-free","celery-free","crustacean-free", "dairy-free", "DASH","egg-free", "fish-free", "fodmap-free", "gluten-free", "immuno-supportive", "keto-friendly", "kidney-friendly", "kosher", "low-fat-abs","low-potassium","low-sugar","lupine-free","Mediterranean","mollusk-free","mustard-free","no-oil-added","paleo","peanut-free","pescatarian","pork-free","red-meat-free","sesame-free","shellfish-free","soy-free","sugar-conscious","sulfite-free","tree-nut-free","vegan,vegetarian","wheat-free"]
    
    
}