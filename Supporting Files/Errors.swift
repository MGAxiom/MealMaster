//
//  ApiErrors.swift
//  MealMaster
//
//  Created by Maxime Girard on 17/07/2023.
//

import Foundation

//Enums used to define cases for CoreDataErrors and Successes, as well as one Error in APICalls
enum HTTPError: Error {
    case invalidJson
}

enum CoreDataError: Error {
    case failedRecipeSave
    case failedPhotoSave
    case failedNameSave
    case failedAllFetch
    case failedDetailsFetch
    case failedDeletion
    case failedMealSave
    case failedCheck
}
