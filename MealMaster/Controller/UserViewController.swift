//
//  UserViewController.swift
//  MealMaster
//
//  Created by Maxime Girard on 24/07/2023.
//

import UIKit

class UserViewController: UIViewController {
    

    @IBAction func favouriteListButton(_ sender: Any) {
        self.performSegue(withIdentifier: "favouriteList", sender: self)
    }
}
