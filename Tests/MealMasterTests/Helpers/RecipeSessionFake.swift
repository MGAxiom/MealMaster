//
//  RecipeSessionFake.swift
//  MealMaster
//
//  Created by Maxime Girard on 08/09/2023.
//

import Foundation
import Alamofire

class RecipeSessionFake: AFSession {
    
    private let fakeResponse: FakeResponse
    private var acceptableStatusCodes: Range<Int> { 200..<300 }
    
    init(fakeResponse: FakeResponse) {
        self.fakeResponse = fakeResponse
    }
    
    func request(with url: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, callback: @escaping (AFDataResponse<Data?>) -> Void) {
        let httpResponse = fakeResponse.response
        let data = fakeResponse.data
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let result:Result<Data?, AFError>
        if fakeResponse.error != nil {
            result = .failure(fakeResponse.error!)
        } else {
            // Simulate Alamofire .validate()
            if acceptableStatusCodes.contains(httpResponse?.statusCode ?? 500) {
                result = .success(fakeResponse.data)
            } else {
                let reason: AFError.ResponseValidationFailureReason = .unacceptableStatusCode(code: httpResponse?.statusCode ?? 500)
                result = .failure(AFError.responseValidationFailed(reason: reason))
            }
            
        }
        callback(AFDataResponse(request: urlRequest, response: httpResponse, data: data, metrics: .none, serializationDuration: .zero, result: result))
    }
    
    func imageRequest() {
        
    }
}
