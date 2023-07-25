//
//  UserFavouriteForm.swift
//  MealMaster
//
//  Created by Maxime Girard on 26/07/2023.
//

import UIKit

class UserFavouriteForm: UIViewController {
    let mealArray = ["Breakfast", "Lunch", "Break", "Dinner"]
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var mealPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker?.locale = .current
        
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let strDate = dateFormatter.string(from: datePicker.date)
        let mealIndex = mealPicker.selectedRow(inComponent: 0)
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
