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
    
    @IBOutlet var tutorialLabel: UILabel!
    @IBOutlet weak var favouriteRecipeListTV: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavouriteRecipes()
        self.favouriteRecipeListTV.reloadData()
        tutorialLabel.text = """
            1. To add and see your favourite recipes, go to the Recipes Tab and make a request
            
            2. Tap on a recipe to see its details
            
            3. Tap the star to add it to your favourites
            
            4. Tap the filled star again to remove it from your favourites
            """
    }
    
    private func fetchFavouriteRecipes() {
        repository.readFavouriteData(completion: { result in
            switch result {
            case .success(let data):
                self.favouriteUserData = data
            case .failure(let failure):
                self.handleCoreDataErrorAlert(error: failure)
            }
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
        let recipeResult = repository.getRecipe(id: favouriteUserData[indexPath.row].recipe!.title!)
        switch recipeResult {
        case .success(let success):
            favouriteRecipeDetails = success
        case .failure(let error):
            self.handleCoreDataErrorAlert(error: error)
        }
        self.performSegue(withIdentifier: "showRecipeDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipeDetails" {
            let controller = segue.destination as! RecipeDetailVC
            controller.data = favouriteRecipeDetails
        }
    }
}
