//
//  RecipeDetailVC.swift
//  MealMaster
//
//  Created by Maxime Girard on 18/07/2023.
//

import UIKit
import AlamofireImage

class RecipeDetailVC: UIViewController {

    var data: Recipe?
    private let repository = CoreDataCRUD()
    var ingredientsArray: [String] {
        get {
            if let recipeData = data, let ingredientsData: String = recipeData.ingredients {
                return ingredientsData.components(separatedBy: ", ")
            }
            return []
        }
    }
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nbOfIngLabel: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRecipeDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfFavorite()
    }
    
    @IBAction func instructionsButton(_ sender: Any) {
        if let url = URL(string: data?.url ?? "") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func saveFavoriteButton(_ sender: Any) {
        if ((data?.favourite) != nil) {
            presentAlertVC(with: "This recipe is already in your favourites. Do you want to remove it?", favourite: (data?.favourite)!)
        } else {
            saveRecipe()
            checkIfFavorite()
        }
    }
    
    @IBAction func planningButton(_ sender: Any) {
        self.performSegue(withIdentifier: "planningForm", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "planningForm" {
            let aboutViewController = segue.destination as! RecipeForm
            aboutViewController.recipeData = data
        }
    }
    
    private func saveRecipe() {
        guard data != nil else {
            return
        }
        repository.saveRecipe(recipe: data!) { result in
            switch result {
            case .success(let success):
                self.handleCoreDataSuccessAlert(success: success)
            case .failure(let error):
                self.handleCoreDataErrorAlert(error: error)
            }
        }
    }
    
    func checkIfFavorite() {
        // TODO : now only check that recipe.favourite exists
        if ((data?.favourite) != nil) {
            favoriteButton.image = Image(systemName: "star.fill")
        } else {
            favoriteButton.image = Image(systemName: "star")
        }
    }
    
    func setUpRecipeDetails() {
        let nbOfIngs = String(data?.foods?.components(separatedBy: ",").count ?? 0)
        let url = URL(string: data?.imageUrl ?? "")!
        recipeImage.af.setImage(withURL: url)
        recipeTitle.text = data?.title
        caloriesLabel.text = data?.calories
        timeLabel.text = data?.time
        originLabel.text = data?.origin?.capitalized
        nbOfIngLabel.text = nbOfIngs
    }
}

extension RecipeDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 5
        cell.textLabel?.text = " - \(ingredientsArray[indexPath.row].capitalized)"
        cell.textLabel?.font = UIFont(name: "System", size: 15)
        cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return cell
    }
}

extension RecipeDetailVC {
    
    func presentAlertVC(with message: String, favourite: Favourite, okCompletion: @escaping (() -> ()) = {}, cancelCompletion: @escaping (() -> ()) = {}, presentCompletion: @escaping (() -> ()) = {}) {
        let alertController = UIAlertController(title: "Ooops !", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
//            CoreDataCRUD().deleteRecipe(id: recipeName)
            CoreDataCRUD().deleteFavourite(favorite: favourite) { result in
                switch result {
                case .success(let success):
                    self.handleCoreDataSuccessAlert(success: success)
                case .failure(let error):
                    self.handleCoreDataErrorAlert(error: error)
                }
            }
            self.checkIfFavorite()
            okCompletion()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel: UIAlertAction) in
            cancelCompletion()
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true) {
                presentCompletion()
            }
        }
    }
}
