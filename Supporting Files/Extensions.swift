//
//  Extensions.swift
//  MealMaster
//
//  Created by Maxime Girard on 31/07/2023.
//

import Foundation
import UIKit

//Extension of Formatter used to create specific date format as a String
extension Formatter {
    static let date: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EE, MMM d, yy"
        return dateFormatter
    }()
}

//Extension of Date used to create a Date() of current date starting at noon to evade risks of wrong dates
extension Date {
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}

//Extension of UIViewController used to create specific UIAlerts depending on error cases for CoreDataError Enum
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

//Extension of UIViewController used to create specific UIAlerts depending on error cases for APIErrors Enum
extension UIViewController {
    func handleApiError(error: HTTPError) {
        var alertText, alertMessage: String
        switch error {
        case .invalidJson:
            alertText = "Error !"
            alertMessage = "Could not decode the json file"
        }
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

