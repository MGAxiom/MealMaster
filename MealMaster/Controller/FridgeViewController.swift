//
//  FridgeViewController.swift
//  MealMaster
//
//  Created by Maxime Girard on 26/07/2023.
//

import UIKit

class FridgeViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var foodTableView: UITableView!
    @IBOutlet var searchActivity: UIActivityIndicatorView!
    
    var foodAPIResult: [Food] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchActivity.isHidden = true
//        tutorialLabel1.text = """
//            1. Start by adding ingredients, or meal names in the search bar
//
//            2. Tap the search button
//
//            3. Scroll through all those delicious recipes
//
//            4. Tap on one of the recipes to get more details
//            """
        
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {

        self.searchButton.isHidden = true
        self.searchActivity.isHidden = false
        fetchFoods()
    }
    
    func fetchFoods() {
        FoodSearch.shared.foodAPI(userInput: searchBar.text!) { response in
            switch response {
            case .success(let result):
                self.foodAPIResult = result
                self.foodTableView.reloadData()
                self.searchButton.isHidden = false
                self.searchActivity.isHidden = true
            case .failure(let error):
                self.resetSearchButton()
                self.handleApiError(error: error)
            }
        }
    }
    
    func resetSearchButton() {
        searchButton.isHidden = false
        searchActivity.isHidden = true
    }
}

extension FridgeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodAPIResult.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "fridgeCell", for: indexPath) as? FoodTableViewCell else {
            return UITableViewCell()
        }
        let food = foodAPIResult[indexPath.row]
        
        cell.configureCell(imageURL: food.image ?? "", title: food.label ?? "", brand: food.brand ?? "", category: food.category ?? "")
        return cell
    }
}
