//
//  UserSettings.swift
//  MealMaster
//
//  Created by Maxime Girard on 08/08/2023.
//

import Foundation
import CoreData

class UserSettings: NSManagedObject {
    
    private var internalAllergySet: Set<String> {
        get {
            guard let unwrappedAllergy: String = allergies, unwrappedAllergy != "" else {
                    return []
            }
            return Set(unwrappedAllergy.components(separatedBy: ";"))
        }
        set (newAllergySet) {
            allergies = newAllergySet.filter{$0 != ""}.joined(separator: ";")
            do {
                try CoreDataStack.sharedInstance.viewContext.save()
            } catch {
                print("can't update")
            }
        }
    }
    
    var allergySet: Set<String> {
        return internalAllergySet
    }
    
    static var currentSettings: UserSettings {
        let request: NSFetchRequest<UserSettings> = UserSettings.fetchRequest()
        request.fetchLimit = 1
        
        do {
            let userSettings = try CoreDataStack.sharedInstance.viewContext.fetch(request).first
            guard let fetchedUserSettings = userSettings else {
                return createUserSettings()
            }
            return fetchedUserSettings
        } catch {
            return createUserSettings()
        }
    }
    
    private static func createUserSettings() -> UserSettings {
        let userSetting = UserSettings(context: CoreDataStack.sharedInstance.viewContext)
        do {
            try CoreDataStack.sharedInstance.viewContext.save()
        } catch {
            print("can't create usersettings")
        }
        return userSetting
    }
    
    func addAllergy(allergy: Diet.Allergies) {
        let allergyName = allergy.info.name.lowercased()
        if (internalAllergySet.contains(allergyName)) {
            return
        }
        internalAllergySet.insert(allergyName)
    }
    
    func addDiet(diet: Diet) {
        let dietName = diet.apiInfo
        if (internalAllergySet.contains(dietName)) {
            return
        }
        let dietsToRemove : Set<String> = Set(
            Diet.allCases.map {$0.apiInfo}
        )
        var tempSet = Set(internalAllergySet).subtracting(dietsToRemove)
        tempSet.insert(dietName)
        internalAllergySet = tempSet
    }
    
    func removeAllergy(allergy: Diet.Allergies) {
        let allergyName = allergy.info.name.lowercased()
        if (!internalAllergySet.contains(allergyName)) {
            return
        }
        internalAllergySet.remove(allergyName)
    }
    
    func hasAllergy(allergy: Diet.Allergies) -> Bool {
        return internalAllergySet.contains(allergy.info.name.lowercased())
    }
    
}
