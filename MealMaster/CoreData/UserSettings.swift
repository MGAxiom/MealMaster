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
            guard let unwrappedAllergy: String = allergies else {
                    return []
            }
            return Set(unwrappedAllergy.components(separatedBy: ";"))
        }
        set (newAllergySet) {
            allergies = newAllergySet.joined(separator: ";")
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
    
    func addAllergy(allergy: Allergies) {
        let allergyName = allergy.info.name.lowercased()
        if (internalAllergySet.contains(allergyName)) {
            return
        }
        internalAllergySet.insert(allergyName)
//        var currentAllergies = allergySet
//        currentAllergies.insert(allergyName)
//        allergies = currentAllergies.joined(separator: ";")
//
//        do {
//            try CoreDataStack.sharedInstance.viewContext.save()
//        } catch {
//            print("can't add")
//        }
    }
    
    func removeAllergy(allergy: Allergies) {
        let allergyName = allergy.info.name.lowercased()
        if (!internalAllergySet.contains(allergyName)) {
            return
        }
        internalAllergySet.remove(allergyName)
//        var currentAllergies = allergySet
//        currentAllergies.remove(allergyName)
//        allergies = currentAllergies.joined(separator: ";")
//
//        do {
//            try CoreDataStack.sharedInstance.viewContext.save()
//        } catch {
//            print("can't remove")
//        }
    }
    
    func hasAllergy(allergy: Allergies) -> Bool {
        return internalAllergySet.contains(allergy.info.name.lowercased())
    }
    
}
