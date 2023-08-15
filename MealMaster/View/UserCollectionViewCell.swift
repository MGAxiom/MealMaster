//
//  UserCollectionViewCell.swift
//  MealMaster
//
//  Created by Maxime Girard on 26/07/2023.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet var cellView: UIView!

    private var allergy: Diet.Allergies?
    var isActive: Bool = false
    
    func updateCellBeauty() {
        if isActive {
            layer.borderWidth = 2.0
        } else {
            layer.borderWidth = 0.0
        }
    }
    
    func toggleSelectedState() {
        guard let theAllergy = allergy else {
            return
        }
        isActive = !isActive
        if isActive {
            // Selected
            UserSettings.currentSettings.addAllergy(allergy: theAllergy)
        } else {
            // Deselected
            UserSettings.currentSettings.removeAllergy(allergy: theAllergy)
        }
        updateCellBeauty()
    }
    
    func configureUserCell(allergyCase: Diet.Allergies) {
        cellLabel.text = allergyCase.info.name
        cellImage.image = UIImage(named: allergyCase.info.imageName)
        allergy = allergyCase
        isActive = UserSettings.currentSettings.hasAllergy(allergy: allergyCase)
        updateCellBeauty()
    }
}
