//
//  GooglePlacesAutocompleteApi.swift
//  GooglePlacesSearch
//
//  Created by Himanshi Bhardwaj on 8/28/17.
//  Copyright © 2017 Himanshi Bhardwaj. All rights reserved.
//
// parts of code taken/inspired from https://github.com/watsonbox/ios_google_places_autocomplete

import Foundation

open class GooglePlacesAutocompleteApi {
    
    //--------------------------------------
    // MARK: Variables
    //--------------------------------------
    
    private let apiKey = GooglePlaceAutoCompleteData.apiKey
    private let placeType = GooglePlaceAutoCompleteData.placeType
    private var placesFound: [Place] = []
    private var errorInfindingPlaces : String = ""
    private var places = [Place]()
    
    
    //--------------------------------------
    // MARK: Functions
    //--------------------------------------
    
    open func getPlaces(_ searchString: String, completion: @escaping (([Place]?, Error?) -> Void)) {
        let params = ["input": searchString,
                      "types": placeType.description,
                      "key": apiKey
        ]
        
        if (searchString == ""){
            let error = NSError(domain: "GooglePlacesAutocompleteErrorDomain"
                , code: 1000, userInfo: [NSLocalizedDescriptionKey:"No search string given"])
            completion(nil,error)
            return
        }
        
        GooglePlacesRequest.doRequest(GooglePlaceAutoCompleteData.httpURLDetails, params: params) {
            json, error in
            if let json = json {
                if let predictions = json["predictions"] as? Array<[String: Any]> {
                    self.places = predictions.map { (prediction: [String: Any]) -> Place in
                        return Place(prediction: prediction, apiKey: self.apiKey)
                    }
                    
                    completion(self.places, error)
                    self.placesFound = self.places
                    
                } else {
                    completion(nil, error)
                }
            } else {
                completion(nil,error)
                
            }
        }
    }
}
