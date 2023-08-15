//
//  ApiErrors.swift
//  MealMaster
//
//  Created by Maxime Girard on 17/07/2023.
//

import Foundation

enum HTTPError: Error {
    case invalidJson
    case commonError(Error)
}

enum CoreDataError: Error {
    case failedSave
    case failedAllFetch
    case failedDetailsFetch
    case failedDeletion
}

enum CoreDataSuccess {
    case successfullPlanningSave
    case successfullFavouriteSave
    case successfullDeletion
}
