//
//  TestAFRequest.swift
//  MealMaster
//
//  Created by Maxime Girard on 08/09/2023.
//

import Alamofire

public class TestAlamoFireRequest {
    
    var request: String?
    struct response{
        static var data: HTTPURLResponse?
        static var json: AnyObject?
        static var error: NSError?
    }
    
    init (request: String){
        self.request = request
    }
    
    public func responseJSON(options: JSONSerialization.ReadingOptions = .allowFragments, completionHandler: (NSURLRequest, HTTPURLResponse?, AnyObject?, NSError?) -> Void) -> Self {
        
        completionHandler(NSURLRequest(url: NSURL(string:self.request!)! as URL), TestAlamoFireRequest.response.data, TestAlamoFireRequest.response.json, TestAlamoFireRequest.response.error)
        return self
    }
    
    
    
}
