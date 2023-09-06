//
//  FridgeSearchViewController.swift
//  MealMaster
//
//  Created by Maxime Girard on 02/09/2023.
//

import UIKit

class FridgeSearchViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var foodSearchTableView: UITableView!
    @IBOutlet var searchActivityWheel: UIActivityIndicatorView!
    @IBOutlet var tutorialLabel: UILabel!
    
    var foodAPIResult: [Food] = []
    private let repository = CoreDataCRUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchActivityWheel.isHidden = true
        tutorialLabel.text = """
            1. Here you can search some food to add to your fridge
            
            2. Start searching by adding the name of your food in the search bar
            
            3. Then tap the search button to see the result
            
            4. If you want to add a particular item to your fridge, tap the heart button
            
            5. You can also change the quantity of an item by tapping the plus and minus buttons
            """
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        self.tutorialLabel.isHidden = true
        self.searchButton.isHidden = true
        self.searchActivityWheel.isHidden = false
        fetchFoods(with: searchBar.text!)
    }
    
    func fetchFoods(with text: String) {
        FoodSearch.shared.foodAPI(userInput: text) { response in
            switch response {
            case .success(let result):
                self.foodAPIResult = result
                self.foodSearchTableView.reloadData()
                self.searchButton.isHidden = false
                self.foodSearchTableView.isHidden = false
                self.searchActivityWheel.isHidden = true
            case .failure(let error):
                self.resetSearchButton()
                self.handleApiError(error: error)
            }
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.foodSearchTableView.isHidden = true
        self.tutorialLabel.isHidden = false
        self.view.layoutIfNeeded()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.foodSearchTableView.isHidden = true
            self.tutorialLabel.isHidden = false
        } else {self.foodSearchTableView.isHidden = false
            self.tutorialLabel.isHidden = true
            fetchFoods(with: searchText)
        }
    }
    
    
    func resetSearchButton() {
        searchButton.isHidden = false
        searchActivityWheel.isHidden = true
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}

extension FridgeSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as? FoodTableViewCell else {
            return UITableViewCell()
        }
        let food = foodAPIResult[indexPath.row]
        cell.configureCell(food: food)
        return cell
    }
}

extension FridgeSearchViewController: UpdateFoodCell {
    
    func getFoodQuantity(name: String) -> String {
        do {
            let foodOfFridge = try repository.getFridgeDetails(name: name)
            print(foodOfFridge)
            return foodOfFridge.quantity ?? ""
        } catch {
            self.handleCoreDataErrorAlert(error: .failedDetailsFetch)
            return "1"
        }
    }
}


