//
//  RecipesTVCell.swift
//  MealMaster
//
//  Created by Maxime Girard on 13/07/2023.
//

import UIKit
import AlamofireImage

class RecipesTVCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellRecipeTitle: UILabel!
    @IBOutlet weak var cellRecipeDescription: UILabel!
    @IBOutlet weak var cellCalories: UILabel!
    @IBOutlet weak var cellNbIngredients: UILabel!
    @IBOutlet weak var cellOrigin: UILabel!
    @IBOutlet weak var cellTime: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(imageURL: String, title: String, description: String, calories: String, origin: String, ingredients: String, time: String) {
        let url = URL(string: imageURL)!
        cellImageView.af.setImage(withURL: url)
        cellRecipeTitle.text = title
        cellRecipeDescription.text = description
        cellTime.text = time
        cellOrigin.text = origin
        cellCalories.text = calories
        cellNbIngredients.text = ingredients
    }
}
