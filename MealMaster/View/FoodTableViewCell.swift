//
//  TableViewCell.swift
//  MealMaster
//
//  Created by Maxime Girard on 31/08/2023.
//

import UIKit
import AlamofireImage

protocol UpdateFoodCell: AnyObject {
    func getFoodQuantity(name: String) -> String
}

class FoodTableViewCell: UITableViewCell {
    
    @IBOutlet var foodImage: UIImageView!
    @IBOutlet var foodTitle: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    @IBOutlet var fridgeButton: UIButton!
    
    var defaultQuantity: Int = 1
    var tempFood: Food?
    private let repository = CoreDataCRUD()
    var isInFridge: Bool = false
    weak var delegate: UpdateFoodCell?

    func configureCell(food: Food?) {
        tempFood = food
        foodTitle.text = food?.label
        brandLabel.text = food?.brand
        categoryLabel.text = food?.category
        isInFridge = checkIfSaved(name: food?.label ?? "", brand: food?.brand ?? "")
        if isInFridge {
            quantityLabel.text = self.delegate?.getFoodQuantity(name: foodTitle.text ?? "")
        } else {
            quantityLabel.text = String(defaultQuantity)
        }
        toggleButtonImage()
        if food?.image == nil {
            foodImage.image = UIImage(named: "unknown-image-food")
        } else {
            guard let url = URL(string: food?.image ?? "") else {
                return
            }
            foodImage.af.setImage(withURL: url)
        }
        guard let url = URL(string: food?.image ?? "") else {
            return
        }
        foodImage.af.setImage(withURL: url)
    }
    
    func checkIfSaved(name: String, brand: String) -> Bool {
        do {
            if try repository.checkIfInFridge(name: name, brand: brand) == true {
                return true
            }
        } catch {
            return false
        }
        return false
    }
    
    func setupQuantity() {
        if checkIfSaved(name: foodTitle.text ?? "", brand: brandLabel.text ?? "") == true {
            quantityLabel.text = self.delegate?.getFoodQuantity(name: foodTitle.text ?? "")
        } else {
            quantityLabel.text = String(defaultQuantity)
        }
    }
    
    @IBAction func fridgeButtonAction(_ sender: Any) {
        checkIfFridged()
    }
    
    @IBAction func minusButtonAction(_ sender: Any) {
        var newValue = Int(quantityLabel.text!)
        if newValue! <= 1 {
            quantityLabel.text = "1"
        } else {
            let finalValue = newValue! - 1
            quantityLabel.text = String(finalValue)
        }
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        var newValue = Int(quantityLabel.text!)
        let finalValue = newValue! + 1
        quantityLabel.text = String(finalValue)
    }
    
    func checkIfFridged() {
        guard let simpleFood = tempFood else { return }
        if !isInFridge {
            addFood(food: simpleFood)
            isInFridge = true
            toggleButtonImage()
        } else {
            deleteFood(food: simpleFood)
            isInFridge = false
            toggleButtonImage()
        }

    }
    
    func addFood(food: Food) {
        do {
            try repository.save(food: food, quantity: quantityLabel.text ?? "")
            toggleButtonImage()
        } catch {
        }
    }
    
    func deleteFood(food: Food?) {
        guard let finalFood = food else { return }
        do {
            try repository.delete(food: finalFood)
        } catch {
        }
    }
    
    func toggleButtonImage() {
        if isInFridge {
            fridgeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            fridgeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}
