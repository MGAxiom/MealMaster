//
//  FridgeTableViewCell.swift
//  MealMaster
//
//  Created by Maxime Girard on 05/09/2023.
//

import UIKit
import AlamofireImage

protocol UpdateCustomCell: AnyObject {
    func foodDelete(food: Food?, cell: UITableViewCell)
    
    func updateFood(name: String, quantity: String, cell: UITableViewCell)
}

class FridgeTableViewCell: UITableViewCell {
    
    @IBOutlet var foodImage: UIImageView!
    @IBOutlet var foodTitle: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var addButton: FridgeButton!
    @IBOutlet var minusButton: FridgeButton!
    @IBOutlet var removeButton: FridgeButton!
    
    private let repository = CoreDataCRUD()
    weak var delegate: UpdateCustomCell?
    
    @objc func fridgeButtonPressed(sender: FridgeButton) {
        self.delegate?.foodDelete(food: sender.food, cell: self)
    }
    
    @objc func addButtonPressed(sender: FridgeButton) {
        let newValue = Int(quantityLabel.text!)
        let finalValue = newValue! + 1
        quantityLabel.text = String(finalValue)
        self.delegate?.updateFood(name: foodTitle.text ?? "", quantity: quantityLabel.text ?? "", cell: self)
    }
    
    @objc func minusButtonPressed(sender: FridgeButton) {
        let newValue = Int(quantityLabel.text!)
        if newValue! <= 1 {
            quantityLabel.text = "1"
        } else {
            let finalValue = newValue! - 1
            quantityLabel.text = String(finalValue)
        }
        self.delegate?.updateFood(name: foodTitle.text ?? "", quantity: quantityLabel.text ?? "", cell: self)
    }
    
    func configureCell(food: Food?, delegate: UpdateCustomCell, name: String, brand: String, category: String, quantity: String, image: String) {
        self.delegate = delegate
        removeButton.food = food
        foodTitle.text = name
        brandLabel.text = brand
        categoryLabel.text = category
        quantityLabel.text = quantity
        removeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        removeButton.addTarget(
            self,
            action: #selector(fridgeButtonPressed),
            for: .touchUpInside)
        addButton.addTarget(
            self,
            action: #selector(addButtonPressed),
            for: .touchUpInside)
        minusButton.addTarget(
            self,
            action: #selector(minusButtonPressed),
            for: .touchUpInside)
        guard let url = URL(string: image), image != "" else {
            foodImage.image = UIImage(named: "unknown-image-food")
            return
        }
            foodImage.af.setImage(withURL: url)
    }
}
