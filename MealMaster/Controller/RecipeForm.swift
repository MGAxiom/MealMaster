//
//  RecipeForm.swift
//  MealMaster
//
//  Created by Maxime Girard on 19/07/2023.
//

import UIKit
import CoreData

class RecipeForm: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var recipeData: Recipe?
    let repository = CoreDataCRUD()
    let mealArray = ["Breakfast", "Lunch", "Break", "Dinner"]
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var mealPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker?.locale = .current
        datePicker?.minimumDate = Date()
        
    }

    @IBAction func confirmButton(_ sender: Any) {
        let strDate = Formatter.date.string(from: datePicker.date)
        let mealIndex = mealPicker.selectedRow(inComponent: 0)
        let mealSelected = mealArray[mealIndex]
        do {
            if try repository.checkIfPlanned(date: strDate, meal: mealSelected) == true {
                let planningDay = try repository.get(date: strDate)
                presentAlertVC(with: "This recipe is already in your planning. Do you want to overwrite the other recipe?", recipeName: (recipeData?.title)!, day: planningDay, mealName: mealSelected, date: strDate, index: mealIndex)
            } else {
                do {
                    try repository.add(meal: mealSelected, date: strDate, for: recipeData!)
                } catch {
                    self.handleCoreDataErrorAlert(error: .failedMealSave)
                }
                navigationController?.popViewController(animated: true)
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        } catch {
            self.handleCoreDataErrorAlert(error: .failedCheck)
        }
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
// MARK: - PickerView Setup
    
    func numberOfComponents(in mealPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ mealPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mealArray.count
    }
    
    func pickerView(_ mealPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = mealArray[row]
        return row
    }
}

extension RecipeForm {
    
    func presentAlertVC(with message: String, recipeName: String, day: PlanningDay?,mealName: String, date: String, index: Int, okCompletion: @escaping (() -> ()) = {}, cancelCompletion: @escaping (() -> ()) = {}, presentCompletion: @escaping (() -> ()) = {}) {
        let alertController = UIAlertController(title: "Ooops !", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Update", style: .default) { (action: UIAlertAction) in
            let meal2Delete = day?.meals?.first(where: { meal in
                return (meal as! PlanningMeal).meal == mealName
            })
            do {
                try self.repository.delete(meal: meal2Delete as! PlanningMeal)
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            } catch {
                let error = CoreDataError.failedDeletion
                self.handleCoreDataErrorAlert(error: error)
            }
            
            do {
                try self.repository.add(meal: mealName, date: date, for: self.recipeData!)
            } catch {
                self.handleCoreDataErrorAlert(error: .failedMealSave)
            }
            okCompletion()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel: UIAlertAction) in
            cancelCompletion()
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true) {
                presentCompletion()
            }
        }
    }
}
