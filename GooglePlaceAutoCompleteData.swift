//
//  GooglePlaceAutoCompleteData.swift
//  GooglePlacesSearch
//
//  Created by Himanshi Bhardwaj on 8/24/17.
//  Copyright © 2017 Himanshi Bhardwaj. All rights reserved.
//

struct GooglePlaceAutoCompleteData {
    
    //--------------------------------------
    // MARK: Variables
    //--------------------------------------
    
    public static let httpURL = "https://maps.googleapis.com/maps/api/place/details/json"
    public static let httpURLDetails = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    public static let apiKey =  "" //Put your apiKey here
    public static var meterToMilesMultiple = 0.000621371
    public static var placeType = PlaceType.Cities.description
    
    
    //--------------------------------------
    // MARK: Functions
    //--------------------------------------
    
    public static func updatePlaceType(to placeType: PlaceType) {
        GooglePlaceAutoCompleteData.placeType = placeType.description
    }
}
