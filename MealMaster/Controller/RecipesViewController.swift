//
//  ViewController.swift
//  MealMaster
//
//  Created by Maxime Girard on 06/07/2023.
//

import UIKit

class RecipesViewController: UIViewController {
    
    var apiResult: [Recipe] = []
    var recipeDetails: Recipe?
    
    
    @IBOutlet weak var recipesListTV: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicatorW: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchButton(_ sender: Any) {
        self.searchButton.isHidden = true
        self.activityIndicatorW.isHidden = false
        fetchRecipes()
        
        
    }
    
    
    func fetchRecipes() {
        RecipeSearch.shared.recipeAPI(userInput: searchTextField.text!) { response in
            switch response {
            case .success(let result):
                self.apiResult = result
                self.recipesListTV.reloadData()
                self.searchButton.isHidden = false
                self.activityIndicatorW.isHidden = true
            case .failure(let error):
                print(error)
            }
        }
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
        return 126
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipesTVCell else {
            return UITableViewCell()
        }
        let recipe = apiResult[indexPath.row]
        let nbOfIng = String(recipe.foods?.components(separatedBy: ",").count ?? 0)
        
        cell.configureCell(imageURL: recipe.imageUrl ?? "", title: recipe.title ?? "", description: recipe.foods?.capitalized ?? "", calories: recipe.calories ?? "0", origin: recipe.origin?.capitalized ?? "", ingredients: nbOfIng, time: recipe.time ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipeDetails = apiResult[indexPath.row]
        self.performSegue(withIdentifier: "showRecipeDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipeDetails" {
            let controller = segue.destination as! RecipeDetailVC
            controller.data = recipeDetails
        }
    }
}
