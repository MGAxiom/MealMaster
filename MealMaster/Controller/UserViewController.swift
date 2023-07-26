//
//  UserViewController.swift
//  MealMaster
//
//  Created by Maxime Girard on 24/07/2023.
//

import UIKit

class UserViewController: UIViewController {
    
    
    

    @IBOutlet weak var userViews: UIView!
    @IBOutlet weak var allergiesView: UIView!
    @IBOutlet weak var nbOfPersonsView: UIView!
    @IBOutlet weak var userPic: UIView!
    
    let allergies = ["alcohol-cocktail","alcohol-free","celery-free","crustacean-free", "dairy-free", "DASH","egg-free", "fish-free", "fodmap-free", "gluten-free", "immuno-supportive", "keto-friendly", "kidney-friendly", "kosher", "low-fat-abs","low-potassium","low-sugar","lupine-free","Mediterranean","mollusk-free","mustard-free","no-oil-added","paleo","peanut-free","pescatarian","pork-free","red-meat-free","sesame-free","shellfish-free","soy-free","sugar-conscious","sulfite-free","tree-nut-free","vegan,vegetarian","wheat-free"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let roundViews = [userViews, allergiesView, nbOfPersonsView]
        roundViews.forEach { UIView in
            UIView?.layer.cornerRadius = 10
        }
        userPic.layer.cornerRadius = 70
    }
    
    @IBAction func favouriteListButton(_ sender: Any) {
        self.performSegue(withIdentifier: "favouriteList", sender: self)
    }
}

//extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return allergies.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allergiesCell" , for: indexPath)
//
//        // Configure the cell
//
//        return cell
//    }
//
//}
