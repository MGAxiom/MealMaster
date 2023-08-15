//
//  PlanningCellDelegate.swift
//  MealMaster
//
//  Created by Maxime Girard on 11/08/2023.
//

import Foundation
import UIKit

protocol PlanningCellDelegate: AnyObject {
    func mealButtonTapped(recipe: Recipe?)
    
    func mealDeleteBtnTapped(meal: PlanningMeal?, cell: UICollectionViewCell)
}
