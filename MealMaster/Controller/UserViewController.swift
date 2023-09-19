//
//  UserViewController.swift
//  MealMaster
//
//  Created by Maxime Girard on 24/07/2023.
//

import UIKit
import Photos

class UserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var userViews: UIView!
    @IBOutlet weak var allergiesView: UIView!
    @IBOutlet weak var userPic: UIView!
    @IBOutlet weak var allergiesCV: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var userIconButton: UIButton!
    @IBOutlet var userName: UITextField!
    @IBOutlet var dietSegment: UISegmentedControl!
    @IBOutlet var favouriteButton: UIButton!
    private var diet: Diet?
    var selectedImage: UIImage?
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userName.delegate = self
        let roundViews = [userViews, allergiesView]
        roundViews.forEach { UIView in
            UIView?.layer.cornerRadius = 10
        }
        favouriteButton.layer.cornerRadius = 10
        userName.text = UserSettings.currentSettings.username
        userPic.layer.cornerRadius = 75
        userIconButton.layer.cornerRadius = 75
        dietSegment.removeAllSegments()
        configureDietSegment()
        if let decodedData = Data(base64Encoded: UserSettings.currentSettings.userphoto ?? "", options: .ignoreUnknownCharacters) {
            let image = UIImage(data: decodedData)
            userIconButton.setImage(image, for: .normal)}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.allergiesCV.reloadData()
    }
    
    func configureDietSegment() {
        Diet.allCases.forEach { diet in
            dietSegment.insertSegment(
                action: UIAction(title:diet.info) { (action) in
                    UserSettings.currentSettings.add(diet: diet)
                    self.currentIndex = self.dietSegment.selectedSegmentIndex
                    self.checkIndex(index: "\(self.currentIndex)")
                },
                at: dietSegment.numberOfSegments,
                animated: false
            )
            dietSegment.apportionsSegmentWidthsByContent = true
        }
        let index = UserSettings.currentSettings.index
        dietSegment.selectedSegmentIndex = Int("\(index ?? "0")") ?? 0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = userName.text
        do {
            try UserSettings.currentSettings.add(name: text!)
        } catch {
            self.handleCoreDataErrorAlert(error: .failedNameSave)
        }
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func changeIconButton(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    func checkIndex(index: String) {
        do {
            try UserSettings.currentSettings.add(index: index)
        } catch {
            self.handleCoreDataErrorAlert(error: .failedDetailsFetch)
        }
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
        selectedImage = imagePicked
        picker.dismiss(animated: true, completion: {
            self.userIconButton.isSelected = true
            do {
                try UserSettings.currentSettings.add(photo: (self.selectedImage?.jpegData(compressionQuality: 1)?.base64EncodedString())!)
            } catch {
                self.handleCoreDataErrorAlert(error: .failedPhotoSave)
            }
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
        cell.layer.cornerRadius = 5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? UserCollectionViewCell {
            cell.toggleSelectedState()
        }
    }
}


