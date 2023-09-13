//
//  ApiErrors.swift
//  MealMaster
//
//  Created by Maxime Girard on 17/07/2023.
//

import Foundation

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

enum CoreDataSuccess {
    case successfullPlanningSave
    case successfullFavouriteSave
    case successfullPhotoSave
    case successfullNameSave
    case successfullFavouriteDeletion
    case successfullPlanningDeletion
}
