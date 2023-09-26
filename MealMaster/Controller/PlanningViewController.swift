//
//  PlanningCollectionViewController.swift
//  MealMaster
//
//  Created by Maxime Girard on 13/07/2023.
//

import UIKit

//Class used to setup and customize PlanningViewController
final class PlanningViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties
    private let repository = CoreDataCRUD()
    private var planningPerDay: [String:PlanningDay?] = [:]
    var recipeDetails: Recipe?
    let now = Date()
    
    
    @IBOutlet weak var planningCollectionView: UICollectionView!
    @IBOutlet weak var planningFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.planningCollectionView.reloadData()
        do {
            let data = try repository.getMealsPlanned()
            for planningDay: PlanningDay in data {
                guard let day = planningDay.date else {
                    continue
                }
                self.planningPerDay[day] = planningDay
            }
        } catch {
            self.handleCoreDataErrorAlert(error: .failedAllFetch)
        }
    }
    
    func dates(for date: Date) -> [String] {
        let endDateString = Formatter.date.string(from: date)
        guard var endDate = Formatter.date.date(from: endDateString)?.noon else { return [] }
        endDate = Calendar.current.date(byAdding: .day, value: 31, to: endDate)!
        var date = Date().noon
        var dates: [String] = []
        while date <= endDate {
            dates.append( Formatter.date.string(from: date))
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        return dates
    }
}
    
    // MARK: UICollectionViewDataSource
extension PlanningViewController: UICollectionViewDelegateFlowLayout {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return dates(for: now).count
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionviewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: collectionView.bounds.height)
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? PlanningCollectionViewCell else {
            return UICollectionViewCell()
        }
        let dateString = dates(for: now)[indexPath.row]
        cell.configurePlanningCell(day: planningPerDay[dateString, default: nil], date: dateString, delegate: self)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipeDetails" {
            let controller = segue.destination as! RecipeDetailVC
            controller.data = recipeDetails
        }
    }
}

extension PlanningViewController: PlanningCellDelegate {
    func mealButtonTapped(recipe: Recipe?) {
        if recipe == nil {
            self.tabBarController?.selectedIndex = 0
        } else {
            recipeDetails = recipe
            self.performSegue(withIdentifier: "showRecipeDetails", sender: self)
        }
    }
    
    func mealDeleteBtnTapped(meal: PlanningMeal?, cell: UICollectionViewCell) {
        guard let theMeal = meal else {
            return
        }
        do {
            try repository.delete(meal: theMeal)
            guard let index = self.planningCollectionView.indexPath(for: cell) else {
                return
            }
            self.planningCollectionView.reloadItems(at: [index])
        } catch {
            self.handleCoreDataErrorAlert(error: .failedDeletion)
        }
    }
}
