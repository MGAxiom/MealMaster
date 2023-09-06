//
//  Extensions.swift
//  MealMaster
//
//  Created by Maxime Girard on 31/07/2023.
//

import Foundation
import UIKit

extension Formatter {
    static let date: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EE, MMM d, yy"
        return dateFormatter
    }()
}

extension Date {
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}

extension UIViewController {
    func handleCoreDataErrorAlert(error: CoreDataError) {
        var alertText, alertMessage: String
        switch error {
        case .failedRecipeSave:
            alertText = "Error"
            alertMessage = "Error occured while trying to save recipe"
        case .failedMealSave:
            alertText = "Error"
            alertMessage = "Error occured while trying to save the meal in the planning"
        case .failedPhotoSave:
            alertText = "Error"
            alertMessage = "Error occured while trying to save your photo"
        case .failedNameSave:
            alertText = "Error"
            alertMessage = "Error occured while trying to save your name"
        case .failedAllFetch:
            alertText = "Error"
            alertMessage = "Error occured while trying to fetch all recipes"
        case .failedDetailsFetch:
            alertText = "Error"
            alertMessage = "Error occured while trying fetch recipe details"
        case .failedDeletion:
            alertText = "Error"
            alertMessage = "Error occured while trying to delete recipe"
        case .failedCheck:
            alertText = "Error"
            alertMessage = "Error occured while trying to check"
        }
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    func handleCoreDataSuccessAlert(success: CoreDataSuccess) {
        var alertText, alertMessage: String
        switch success {
        case .successfullPlanningSave:
            alertText = "Success !"
            alertMessage = "We've added this recipe to your planning"
        case .successfullFavouriteSave:
            alertText = "Success !"
            alertMessage = "We've added this recipe to your favourites"
        case .successfullNameSave:
            alertText = "Success !"
            alertMessage = "We've saved your name successfully"
        case .successfullPhotoSave:
            alertText = "Success !"
            alertMessage = "We've saved your photo successfully"
        case .successfullFavouriteDeletion:
            alertText = "Success !"
            alertMessage = "This recipe has been deleted from your favourite"
        case .successfullPlanningDeletion:
            alertText = "Success !"
            alertMessage = "This recipe has been deleted from your planning"

        }
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    func handleApiError(error: HTTPError) {
        var alertText, alertMessage: String
        switch error {
        case .invalidJson:
            alertText = "Error !"
            alertMessage = "Could not decode the json file"
        case .commonError(let errorString):
            alertText = "Error !"
            alertMessage = "The error \(errorString) occured during the api call"
            
        }
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

