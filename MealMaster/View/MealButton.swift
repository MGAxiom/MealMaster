//
//  MealButton.swift
//  MealMaster
//
//  Created by Maxime Girard on 11/08/2023.
//

import Foundation
import UIKit

class MealButton: UIButton {
    private var internalRecipe: Recipe?
    var recipe: Recipe? {
        get {
            return internalRecipe
        }
        set(newRecipe) {
            internalRecipe = newRecipe
            setTitle(recipe?.title, for: .normal)
        }
    }
}

class MealDeleteButton: UIButton {
    var meal: PlanningMeal?
}
