//
//  UserViewController.swift
//  MealMaster
//
//  Created by Maxime Girard on 24/07/2023.
//

import UIKit

class UserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userViews: UIView!
    @IBOutlet weak var allergiesView: UIView!
    @IBOutlet weak var nbOfPersonsView: UIView!
    @IBOutlet weak var userPic: UIView!
    @IBOutlet weak var allergiesCV: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var userIconButton: UIButton!
    @IBOutlet var dietSegment: UISegmentedControl!
    private var diet: Diet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let roundViews = [userViews, allergiesView, nbOfPersonsView]
        roundViews.forEach { UIView in
            UIView?.layer.cornerRadius = 10
        }
        userPic.layer.cornerRadius = 70
        userIconButton.layer.cornerRadius = 70
        dietSegment.removeAllSegments()
        configureDietSegment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.allergiesCV.reloadData()
    }
    
    func configureDietSegment() {
        Diet.allCases.forEach { diet in
            dietSegment.insertSegment(
                action: UIAction(title:diet.info) { (action) in
                    UserSettings.currentSettings.addDiet(diet: diet)
                },
                at: dietSegment.numberOfSegments,
                animated: false
            )
        }
    }
    
    @IBAction func dietSegmentControl(_ sender: Any) {
//        guard let theDiet = diet else {
//            return
//        }
//        switch dietSegment.selectedSegmentIndex {
//        case 0:
//            print(theDiet)
////            UserSettings.currentSettings.addDiet(diet: theDiet)
//        case 1:
//            print(theDiet)
////            UserSettings.currentSettings.addDiet(diet: theDiet)
//        case 2:
//            print(theDiet)
////            UserSettings.currentSettings.addDiet(diet: theDiet)
//        case 3:
//            print(theDiet)
////            UserSettings.currentSettings.addDiet(diet: theDiet)
//        default:
//            break
//        }
    }
    
    
    @IBAction func changeIconButton(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func favouriteListButton(_ sender: Any) {
        self.performSegue(withIdentifier: "favouriteList", sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicked = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as! UIImage
        userIconButton.imageView?.contentMode = .scaleAspectFill
        userIconButton.setImage(imagePicked, for: .selected)
        userIconButton.setImage(imagePicked, for: .normal)
        userIconButton.imageView?.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
        
        picker.dismiss(animated: true, completion: {
            self.userIconButton.isSelected = true
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UserViewController: UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Diet.Allergies.allCases.count
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
            allergyCase: Diet.Allergies.allCases[indexPath.row]
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


