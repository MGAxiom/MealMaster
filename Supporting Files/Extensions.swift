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
        case .failedSave:
            alertText = "Error"
            alertMessage = "Error occured while trying to save recipe"
        case .failedAllFetch:
            alertText = "Error"
            alertMessage = "Error occured while trying to fetch all recipes"
        case .failedDetailsFetch:
            alertText = "Error"
            alertMessage = "Error occured while trying fetch recipe details"
        case .failedDeletion:
            alertText = "Error"
            alertMessage = "Error occured while trying to delete recipe"
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
        case .successfullSave:
            alertText = "Success !"
            alertMessage = "We've added this recipe to your favourites"
        case .successfullDeletion:
            alertText = "Success !"
            alertMessage = "This recipe has been deleted from your favourite"

        }
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
