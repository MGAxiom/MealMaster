//
//  PlanningCollectionViewCell.swift
//  MealMaster
//
//  Created by Maxime Girard on 14/07/2023.
//

import UIKit
import CoreData

class PlanningCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var meal1Button: MealButton!
    @IBOutlet weak var meal2Button: MealButton!
    @IBOutlet weak var meal3Button: MealButton!
    @IBOutlet weak var meal4Button: MealButton!
    @IBOutlet weak var mealLabel1: UILabel!
    @IBOutlet weak var mealLabel2: UILabel!
    @IBOutlet weak var mealLabel3: UILabel!
    @IBOutlet weak var mealLabel4: UILabel!
    @IBOutlet var mealDelete1: MealDeleteButton!
    @IBOutlet var mealDelete2: MealDeleteButton!
    @IBOutlet var mealDelete3: MealDeleteButton!
    @IBOutlet var mealDelete4: MealDeleteButton!
    
    
    var day: PlanningDay?
    weak var delegate: PlanningCellDelegate?
    
    @objc func mealButtonPressed(sender: MealButton) {
        self.delegate?.mealButtonTapped(recipe: sender.recipe)
    }
    
    @objc func mealDelButtonPressed(sender: MealDeleteButton) {
        self.delegate?.mealDeleteBtnTapped(meal: sender.meal, cell: self)
    }
    
    func configurePlanningCell(day: PlanningDay?, date: String, delegate: PlanningCellDelegate) {
        self.delegate = delegate
        self.day = day
        mealLabel1.text = "Breakfast"
        mealLabel2.text = "Lunch"
        mealLabel3.text = "Break"
        mealLabel4.text = "Dinner"
        meal1Button.setTitle("Add Meal", for: .normal)
        meal2Button.setTitle("Add Meal", for: .normal)
        meal3Button.setTitle("Add Meal", for: .normal)
        meal4Button.setTitle("Add Meal", for: .normal)
        meal1Button.addTarget(
            self,
            action:#selector(mealButtonPressed),
            for: .touchUpInside
        )
        meal2Button.addTarget(
            self,
            action:#selector(mealButtonPressed),
            for: .touchUpInside
        )
        meal3Button.addTarget(
            self,
            action:#selector(mealButtonPressed),
            for: .touchUpInside
        )
        meal4Button.addTarget(
            self,
            action:#selector(mealButtonPressed),
            for: .touchUpInside
        )
        mealDelete1.addTarget(
            self,
            action:#selector(mealDelButtonPressed),
            for: .touchUpInside
        )
        mealDelete2.addTarget(
            self,
            action:#selector(mealDelButtonPressed),
            for: .touchUpInside
        )
        mealDelete3.addTarget(
            self,
            action:#selector(mealDelButtonPressed),
            for: .touchUpInside
        )
        mealDelete4.addTarget(
            self,
            action:#selector(mealDelButtonPressed),
            for: .touchUpInside
        )
        
        guard let planningDay = day else {
            dateLabel.text = date
            return
        }
        dateLabel.text = date
        guard let meals = planningDay.meals else {
            return
        }
        for planningMeal in meals.allObjects as! [PlanningMeal] {
            switch planningMeal.meal {
            case "Breakfast":
                meal1Button.recipe = planningMeal.recipe
                mealDelete1.meal = planningMeal
            case "Lunch":
                meal2Button.recipe = planningMeal.recipe
                mealDelete2.meal = planningMeal
            case "Break":
                meal3Button.recipe = planningMeal.recipe
                mealDelete3.meal = planningMeal
            case "Dinner":
                meal4Button.recipe = planningMeal.recipe
                mealDelete4.meal = planningMeal
            default:
                break
            }
        }
        checkIfPlanned()
    }
    
    func checkIfPlanned() {
        if meal1Button.recipe != nil {
            mealDelete1.isHidden = false
        }
        if meal2Button.recipe != nil {
            mealDelete2.isHidden = false
        }
        if meal3Button.recipe != nil {
            mealDelete3.isHidden = false
        }
        if meal4Button.recipe != nil {
            mealDelete4.isHidden = false
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        meal1Button.recipe = nil
        mealDelete1.meal = nil
        meal2Button.recipe = nil
        mealDelete2.meal = nil
        meal3Button.recipe = nil
        mealDelete3.meal = nil
        meal4Button.recipe = nil
        mealDelete4.meal = nil
        mealDelete1.isHidden = true
        mealDelete2.isHidden = true
        mealDelete3.isHidden = true
        mealDelete4.isHidden = true
    }
}

