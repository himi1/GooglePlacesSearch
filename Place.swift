//
//  Place.swift
//  GooglePlacesSearch
//
//  Created by Himanshi Bhardwaj on 8/27/17.
//  Copyright © 2017 Himanshi Bhardwaj. All rights reserved.
//

import Foundation

open class Place: NSObject {
    
    //--------------------------------------
    // MARK: Variables
    //--------------------------------------
   
    private let id: String
    private let desc: String
    
    override open var description: String {
        get {
            return desc
        }
    }
    
    //--------------------------------------
    // MARK: Functions
    //--------------------------------------
    
    public init(id: String, description: String) {
        self.id = id
        desc = description
    }
    
    public convenience init(prediction: [String: Any], apiKey: String?) {
        self.init(
            id: prediction["place_id"] as! String,
            description: prediction["description"] as! String
        )
    }
    
    open func getDetails(completion: @escaping (([String : String]?, Error?) -> Void)) {
        var result: [String: String] = [:]
        
        GooglePlacesRequest.doRequest(
            GooglePlaceAutoCompleteData.httpURL,
            params: [
                "placeid": id,
                "key": GooglePlaceAutoCompleteData.apiKey
            ]
        ) { json, error in
            if let json = json as [String: AnyObject]? {
                result = PlaceDetails(json: json).getResult()
            }
            if let error = error as NSError? {
                print("Error fetching google place details: \(error)")
            }
            completion(result, error)
        }
        
    }
}
