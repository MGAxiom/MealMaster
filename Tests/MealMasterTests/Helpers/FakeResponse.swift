//
//  FakeResponse.swift
//  MealMaster
//
//  Created by Maxime Girard on 08/09/2023.
//

import Foundation
import Alamofire

struct FakeResponse {
    var response: HTTPURLResponse?
    var data: Data?
    var error: AFError?
}
