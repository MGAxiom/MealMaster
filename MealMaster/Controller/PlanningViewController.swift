//
//  PlanningCollectionViewController.swift
//  MealMaster
//
//  Created by Maxime Girard on 13/07/2023.
//

import UIKit


final class PlanningViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties
    private let repository = CoreDataCRUD()
    var planningData = [PlanningDetails]()
    let now = Date()
    
    @IBOutlet weak var planningCollectionView: UICollectionView!
    @IBOutlet weak var planningFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repository.getMealsPlanned(completion: { [weak self] data in
            self?.planningData = data
        })
        print(planningData)
//        print(getDaysTitles())
//        print(dates(for: now))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.planningCollectionView.reloadData()
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
        cell.configurePlanningCell(date: dateString, meal1: "Add Meal", meal2: "Add Meal", meal3: "Add Meal", meal4: "Add Meal")
        
        return cell
    }
}
