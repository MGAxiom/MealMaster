//
//  UserViewController.swift
//  MealMaster
//
//  Created by Maxime Girard on 24/07/2023.
//

import UIKit

class UserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var userViews: UIView!
    @IBOutlet weak var allergiesView: UIView!
    @IBOutlet weak var nbOfPersonsView: UIView!
    @IBOutlet weak var userPic: UIView!
    @IBOutlet weak var allergiesCV: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let roundViews = [userViews, allergiesView, nbOfPersonsView]
        roundViews.forEach { UIView in
            UIView?.layer.cornerRadius = 10
        }
        userPic.layer.cornerRadius = 70
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.allergiesCV.reloadData()
    }
    
    @IBAction func favouriteListButton(_ sender: Any) {
        self.performSegue(withIdentifier: "favouriteList", sender: self)
    }
}

extension UserViewController: UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Allergies.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionviewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let columns: CGFloat = 4
        
        let spacing: CGFloat = 5
        let totalHorizontalSpacing = (columns - 1) * spacing
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allergiesCell" , for: indexPath) as? UserCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureUserCell(
            allergyCase: Allergies.allCases[indexPath.row]
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAtIndexPath")
        if let cell = collectionView.cellForItem(at: indexPath) as? UserCollectionViewCell {
            cell.toggleSelectedState()
        }
    }
}
