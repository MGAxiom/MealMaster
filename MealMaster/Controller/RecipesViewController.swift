//
//  ViewController.swift
//  MealMaster
//
//  Created by Maxime Girard on 06/07/2023.
//

import UIKit

class RecipesViewController: UIViewController {

    var apiResult: [Recipe] = []
    
    
    @IBOutlet weak var recipesListTV: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicatorW: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiResult.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipesListTVCell else {
            return UITableViewCell()
        }
        let recipe = apiResult[indexPath.row]
        //        let ingredientLinesString = recipe.decodedIngredientLines.joined(separator: ", ")
        
        cell.configure(imageURL: recipe.imageUrl ?? "" ,title: recipe.title ?? "", subtitle: recipe.ingredients?.capitalized ?? "", calories: recipe.calories ?? "0", time: recipe.time ?? "")
        return cell
    }
}
