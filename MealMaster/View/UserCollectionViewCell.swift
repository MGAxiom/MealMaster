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
    
    func configureUserCell(label: String, allergyAsset: String) {
        cellLabel.text = label
        cellImage.image = UIImage(named: allergyAsset)
    }
}
