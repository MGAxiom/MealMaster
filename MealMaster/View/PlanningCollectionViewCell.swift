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
    @IBOutlet var mealLabels: [UILabel] = []
    @IBOutlet var deleteButton: [MealDeleteButton] = []
    @IBOutlet var mealButton: [MealButton] = []
    
    
    var day: PlanningDay?
    weak var delegate: PlanningCellDelegate?
    
    @objc func mealButtonPressed(sender: MealButton) {
        self.delegate?.mealButtonTapped(recipe: sender.recipe)
    }
    
    @objc func mealDelButtonPressed(sender: MealDeleteButton) {
        self.delegate?.mealDeleteBtnTapped(meal: sender.meal, cell: self)
    }
    
    enum planningCases {
        case Breakfast
        case Lunch
        case Break
        case Dinner
        var info: String {
            switch self {
                
            case .Breakfast:
                return "Breakfast"
            case .Lunch:
                return "Lunch"
            case .Break:
                return "Break"
            case .Dinner:
                return "Dinner"
            }
        }
    }
    
    func configurePlanningCell(day: PlanningDay?, date: String, delegate: PlanningCellDelegate) {
        self.delegate = delegate
        self.day = day
        mealLabels[0].text = planningCases.Breakfast.info
        mealLabels[1].text = planningCases.Lunch.info
        mealLabels[2].text = planningCases.Break.info
        mealLabels[3].text = planningCases.Dinner.info
        mealLabels.forEach { label in
            label.font = UIFont.systemFont(ofSize: 16)
        }
        mealButton.forEach { button in
            button.setTitle("Add Meal", for: .normal)
            button.addTarget(
                self,
                action: #selector(mealButtonPressed),
                for: .touchUpInside)
            if #available(iOS 15.0, *) {
                button.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.font = UIFont.systemFont(ofSize: 13)
                    return outgoing
                }
            } else {
                // Fallback on earlier versions
            }
            button.clipsToBounds = true
            button.titleLabel?.clipsToBounds = true
            if #available(iOS 15.0, *) {
                button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            } else {
                // Fallback on earlier versions
            }
        }
        
        deleteButton.forEach { button in
            button.setTitle("Remove", for: .normal)
            button.addTarget(
                self,
                action: #selector(mealDelButtonPressed),
                for: .touchUpInside)
        }
        
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
            case planningCases.Breakfast.info:
                mealButton[0].recipe = planningMeal.recipe
                deleteButton[0].meal = planningMeal
            case planningCases.Lunch.info:
                mealButton[1].recipe = planningMeal.recipe
                deleteButton[1].meal = planningMeal
            case planningCases.Break.info:
                mealButton[2].recipe = planningMeal.recipe
                deleteButton[2].meal = planningMeal
            case planningCases.Dinner.info:
                mealButton[3].recipe = planningMeal.recipe
                deleteButton[3].meal = planningMeal
            default:
                break
            }
        }
        checkIfPlanned()
    }
    
    func checkIfPlanned() {
        if mealButton[0].recipe != nil {
            deleteButton[0].isHidden = false
        }
        if mealButton[1].recipe != nil {
            deleteButton[1].isHidden = false
        }
        if mealButton[2].recipe != nil {
            deleteButton[2].isHidden = false
        }
        if mealButton[3].recipe != nil {
            deleteButton[3].isHidden = false
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mealButton.forEach { button in
            button.recipe = nil
        }
        deleteButton.forEach { button in
            button.meal = nil
            button.isHidden = true
        }
    }
}


