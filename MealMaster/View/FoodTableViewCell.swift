//
//  TableViewCell.swift
//  MealMaster
//
//  Created by Maxime Girard on 31/08/2023.
//

import UIKit
import AlamofireImage

//Protocol used to setup a Delegate in FridgeSearchController
protocol UpdateFoodCell: AnyObject {
    func getFoodQuantity(name: String) -> String
    func updateFood(name: String, quantity: String, cell: UITableViewCell)
}

//Class used to setup custom FoodTableViewCell
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
        checkIfInFridge(name: food?.label ?? "", brand: food?.brand ?? "") { success in
            if success {
                self.isInFridge = true
            } else {
                self.isInFridge = false
            }
        }
        if isInFridge {
            quantityLabel.text = self.delegate?.getFoodQuantity(name: foodTitle.text ?? "") ?? "nil"
        } else {
            quantityLabel.text = String(defaultQuantity)
        }
        toggleButtonImage()
        guard let url = URL(string: food?.image ?? ""), food?.image != "" else {
            foodImage.image = UIImage(named: "unknown-image-food")
            return
        }
        foodImage.af.setImage(withURL: url)
    }

    func checkIfInFridge(name: String, brand: String, completionHandler:@escaping (Bool) -> ()) {
        do {
            guard let existingFood = try repository.getFoodIfInFridge(name: name, brand: brand) else {
                completionHandler(false)
                return
            }
            tempFood = existingFood
            completionHandler(true)
        } catch {
        }
    }
    
    func setupQuantity() {
        if isInFridge {
            quantityLabel.text = self.delegate?.getFoodQuantity(name: foodTitle.text ?? "")
        } else {
            quantityLabel.text = String(defaultQuantity)
        }
    }
    
    @IBAction func fridgeButtonAction(_ sender: Any) {
        updateFridge()
    }
    
    @IBAction func minusButtonAction(_ sender: Any) {
        let newValue = Int(quantityLabel.text!)
        if newValue! <= 1 {
            quantityLabel.text = "1"
        } else {
            let finalValue = newValue! - 1
            quantityLabel.text = String(finalValue)
        }
        self.delegate?.updateFood(name: foodTitle.text ?? "", quantity: quantityLabel.text ?? "", cell: self)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        let newValue = Int(quantityLabel.text!)
        let finalValue = newValue! + 1
        quantityLabel.text = String(finalValue)
        self.delegate?.updateFood(name: foodTitle.text ?? "", quantity: quantityLabel.text ?? "", cell: self)
    }
    
    func updateFridge() {
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
