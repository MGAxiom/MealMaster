//
//  RecipeForm.swift
//  MealMaster
//
//  Created by Maxime Girard on 19/07/2023.
//

import UIKit

class RecipeForm: UIViewController {
    let mealArray = ["Breakfast", "Lunch", "Break", "Dinner"]
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var mealPicker: UIPickerView!
    
    

    @IBAction func confirmButton(_ sender: Any) {
    }
    
    @IBAction func cancelButton(_ sender: Any) {
    }
}
