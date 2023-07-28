//
//  PlanningCollectionViewController.swift
//  MealMaster
//
//  Created by Maxime Girard on 13/07/2023.
//

import UIKit


final class PlanningViewController: UICollectionViewController {
    
    // MARK: - Properties
    @IBOutlet weak var planningCollectionView: UICollectionView!
    @IBOutlet weak var planningFlowLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.planningCollectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath)

        // Configure the cell

        return cell
    }
}
