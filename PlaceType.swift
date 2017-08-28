//
//  PlaceType.swift
//  GooglePlacesSearch
//
//  Created by Himanshi Bhardwaj on 8/28/17.
//  Copyright © 2017 Himanshi Bhardwaj. All rights reserved.
//

import Foundation

public enum PlaceType: CustomStringConvertible {
    case All
    case Address
    case Cities
    case Establishment
    case Geocode
    case Regions
    
    public var description : String {
        switch self {
        case .All: return ""
        case .Address: return "address"
        case .Cities: return "(cities)"
        case .Establishment: return "establishment"
        case .Geocode: return "geocode"
        case .Regions: return "(regions)"
            
        }
    }
}
