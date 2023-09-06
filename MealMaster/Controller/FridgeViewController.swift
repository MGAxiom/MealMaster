//
//  FridgeViewController.swift
//  MealMaster
//
//  Created by Maxime Girard on 26/07/2023.
//

import UIKit

class FridgeViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var foodTableView: UITableView!
    @IBOutlet var searchActivity: UIActivityIndicatorView!
    @IBOutlet var tutorialLabel: UILabel!
    
    var foodUserData = [Food]()
    private let repository = CoreDataCRUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchActivity.isHidden = true
        tutorialLabel.text = """
            1. This is your fridge
            
            2. To start adding food, tap the "Add Food" button on the top right side corner
            
            3. Any food that you add, will then be shown here
            """
        tutorialLabel.isHidden = false
        foodTableView.isHidden = true
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFridgeInventory()
        foodTableView.reloadData()
    }
    
    private func fetchFridgeInventory() {
        self.foodUserData = readFData()
        foodTableView.reloadData()
    }
    
    @IBAction func goToFoodSearch(_ sender: Any) {
        self.performSegue(withIdentifier: "foodSearchTV", sender: self)
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        self.searchButton.isHidden = true
        self.searchActivity.isHidden = false
        fetchFoods(with: searchBar.text!)
    }
    
    func fetchFoods(with text: String) {
        do {
            let result = try repository.readFridgeDetails(name: text)
            foodUserData = result
            foodTableView.reloadData()
            self.searchButton.isHidden = false
            self.searchActivity.isHidden = true
        } catch {
            self.handleCoreDataErrorAlert(error: .failedAllFetch)
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        fetchFridgeInventory()
        self.view.layoutIfNeeded()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            fetchFridgeInventory()
        } else {
            fetchFoods(with: searchText)
        }
    }
    
    func checkFridgeInventory() {
        if self.foodUserData.count > 0 {
            self.tutorialLabel.isHidden = true
            self.foodTableView.isHidden = false
        } else {
            self.tutorialLabel.isHidden = false
            self.foodTableView.isHidden = true
        }
    }
    
    func resetSearchButton() {
        searchButton.isHidden = false
        searchActivity.isHidden = true
    }
    
    func readFData() -> [Food] {
        do {
            return try repository.readFoodData()
        } catch {
            return foodUserData
        }
    }
}

extension FridgeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodUserData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "fridgeCell", for: indexPath) as? FridgeTableViewCell else {
            return UITableViewCell()
        }
        let food = foodUserData[indexPath.row]
        cell.configureCell(food: food, delegate: self, name: food.label ?? "", brand: food.brand ?? "", category: food.category ?? "", quantity: food.quantity ?? "", image: food.image ?? "")
        cell.delegate = self
        return cell
    }
}

extension FridgeViewController: UpdateCustomCell {
    func updateFood(name: String, quantity: String, cell: UITableViewCell) {
        do {
            try repository.update(name: name, with: quantity)
            fetchFridgeInventory()
            foodTableView.reloadData()
        } catch {
            self.handleCoreDataErrorAlert(error: .failedDeletion)
        }
    }
    
    func foodDelete(food: Food?, cell: UITableViewCell) {
        guard let theFood = food else {
            return
        }
        do {
            try repository.delete(food: theFood)
            fetchFridgeInventory()
            foodTableView.reloadData()
        } catch {
            self.handleCoreDataErrorAlert(error: .failedDeletion)
        }
    }
}
