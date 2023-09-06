//
//  ViewController.swift
//  MealMaster
//
//  Created by Maxime Girard on 06/07/2023.
//

import UIKit
import AlamofireImage

class RecipesViewController: UIViewController {
    
    var apiResult: [Recipe] = []
    var randomAPIResult: [Recipe] = []
    var recipeDetails: Recipe?
    
    
    @IBOutlet weak var recipesListTV: UITableView!
    @IBOutlet weak var searchTextField: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var randomRecipeView: UIView!
    @IBOutlet weak var activityIndicatorW: UIActivityIndicatorView!
    @IBOutlet weak var tutorialLabel1: UILabel!
    
    //MARK: RandomRecipe
    @IBOutlet var randomImage: UIImageView!
    @IBOutlet var randomTitle: UILabel!
    @IBOutlet var randomDescription: UILabel!
    @IBOutlet var randomKCAL: UILabel!
    @IBOutlet var randomIngredients: UILabel!
    @IBOutlet var randomCuisine: UILabel!
    @IBOutlet var randomeTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomImage.layer.cornerRadius = 10
        randomRecipeView.layer.cornerRadius = 10
        recipesListTV.layer.cornerRadius = 10
        searchTextField.searchBarStyle = .minimal
        tutorialLabel1.text = """
            1. Start by adding ingredients, or meal names in the search bar

            2. Tap the search button

            3. Scroll through all those delicious recipes

            4. Tap on one of the recipes to get more details
            """
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        randomRecipeView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        randomRecipe()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        self.tutorialLabel1.isHidden = true
        self.recipesListTV.isHidden = false
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
                self.resetSearchButton()
                self.handleApiError(error: error)
            }
        }
    }
    
    func randomRecipe() {
        RecipeSearch.shared.randomRecipeAPI() { response in
            switch response {
            case .success(let result):
                self.randomAPIResult = result
                let url = URL(string: self.randomAPIResult[0].imageUrl ?? "")!
                self.randomImage.af.setImage(withURL: url)
                self.randomKCAL.text = self.randomAPIResult[0].calories
                self.randomTitle.text = self.randomAPIResult[0].title
                self.randomCuisine.text = self.randomAPIResult[0].origin?.capitalized
                self.randomDescription.text = self.randomAPIResult[0].foods?.capitalized
                self.randomeTime.text = self.randomAPIResult[0].time
            case .failure(let error):
                self.handleApiError(error: error)
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        recipeDetails = randomAPIResult.first
        self.performSegue(withIdentifier: "showRecipeDetails", sender: self)
    }
    
    func resetSearchButton() {
        searchButton.isHidden = false
        activityIndicatorW.isHidden = true
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
