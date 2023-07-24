//
//  PlanningCollectionViewCell.swift
//  MealMaster
//
//  Created by Maxime Girard on 14/07/2023.
//

import UIKit

class PlanningCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var meal1Button: UIButton!
    @IBOutlet weak var meal2Button: UIButton!
    @IBOutlet weak var meal3Button: UIButton!
    @IBOutlet weak var meal4Button: UIButton!
    
    
    func configurePlanningCell(date: String, meal1: String, meal2: String, meal3: String, meal4: String) {
        dateLabel.text = date
        meal1Button.setTitle(meal1, for: .normal)
        meal2Button.setTitle(meal2, for: .normal)
        meal3Button.setTitle(meal3, for: .normal)
        meal4Button.setTitle(meal4, for: .normal)
    }
}
