//
//  PlaceDetails.swift
//  GooglePlacesSearch
//
//  Created by Himanshi Bhardwaj on 8/27/17.
//  Copyright © 2017 Himanshi Bhardwaj. All rights reserved.
//

import Foundation
import CoreLocation

open class PlaceDetails {
    
    //--------------------------------------
    // MARK: Variables
    //--------------------------------------

    private let name: String
    private let latitude: Double
    private let longitude: Double
    private let location: CLLocation
    private var radius: CLLocationDistance
    private var timeZone: String
    private let raw: [String: AnyObject]
    
    
    //--------------------------------------
    // MARK: Functions
    //--------------------------------------

    public init(json: [String: AnyObject]) {
        let result = json["result"] as! [String: AnyObject]
        let geometry = result["geometry"] as! [String: AnyObject]
        let geoLocation = geometry["location"] as! [String: AnyObject]
        let utc_offset = result["utc_offset"] as! Int
        
        name = result["name"] as! String
        latitude = geoLocation["lat"] as! Double
        longitude = geoLocation["lng"] as! Double
        location = CLLocation(latitude: latitude, longitude: longitude)
        
        
        radius = 10 // default
        timeZone = String(utc_offset / 60) +
            ":" +
            String(utc_offset % 60)
        
        if let viewport = geometry["viewport"] as? [String: AnyObject] {
            //Assuming that the place is circular and using the north-east to centre distance to derive the radius
            let northEastDict = viewport["northeast"] as! [String: AnyObject]
            let northEast = CLLocation(latitude: northEastDict["lat"] as! Double, longitude: northEastDict["lng"] as! Double)
            
            radius = self.location.distance(from: northEast) * GooglePlaceAutoCompleteData.meterToMilesMultiple
        }
        raw = json
    }
    
    open func getResult() -> [String:String] {
        var result = [String:String]()
        result["name"] = name
        result["latitude"] = latitude.description
        result["longitude"] = longitude.description
        result["radius"] = String(format: "%.2f", radius) + " Miles"//  radius.description
        result["timeZone"] = "UTC " + timeZone + " hours"
        result["dateAndTime"] = String(describing: location.timestamp)
        
        return result
    }
}
