//
//  UserFavouriteListVC.swift
//  MealMaster
//
//  Created by Maxime Girard on 24/07/2023.
//

import UIKit

class UserFavouriteListVC: UIViewController {
    
    var favouriteUserData = [Favourite]()
    let repository = CoreDataCRUD()
    var favouriteRecipeDetails: Recipe?
    
    @IBOutlet weak var favouriteRecipeListTV: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavouriteRecipes()
        self.favouriteRecipeListTV.reloadData()
        print(favouriteUserData)
    }
    
    private func fetchFavouriteRecipes() {
        repository.readFavouriteData(completion: { [weak self] data in
            self?.favouriteUserData = data
        })
    }
    
}

extension UserFavouriteListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteUserData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteRecipeCell", for: indexPath) as? RecipesTVCell else {
            return UITableViewCell()
        }
        
        guard let recipe = favouriteUserData[indexPath.row].recipe else {
            return cell
        }
        
        let nbOfIng = String(recipe.foods?.components(separatedBy: ",").count ?? 0)
        cell.configureCell(imageURL: recipe.imageUrl ?? "", title: recipe.title ?? "", description: recipe.foods?.capitalized ?? "", calories: recipe.calories ?? "0", origin: recipe.origin?.capitalized ?? "", ingredients: nbOfIng, time: recipe.time ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        favouriteRecipeDetails = repository.getRecipeDetails(id: favouriteUserData[indexPath.row].recipe!.title!)
        self.performSegue(withIdentifier: "showRecipeDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipeDetails" {
            let controller = segue.destination as! RecipeDetailVC
            controller.data = favouriteRecipeDetails
        }
    }
}
