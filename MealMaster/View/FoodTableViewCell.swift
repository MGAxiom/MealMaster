//
//  TableViewCell.swift
//  MealMaster
//
//  Created by Maxime Girard on 31/08/2023.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    @IBOutlet var foodImage: UIImageView!
    @IBOutlet var foodTitle: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    @IBOutlet var removeButton: UIButton!
    
    var defaultQuantity = "1"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(imageURL: String, title: String, brand: String, category: String) {
        guard let url = URL(string: imageURL) else { return }
        foodImage.af.setImage(withURL: url)
        foodTitle.text = title
        brandLabel.text = brand
        categoryLabel.text = category
        quantityLabel.text = defaultQuantity
    }
    
    
}
