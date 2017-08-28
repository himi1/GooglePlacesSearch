//
//  ErrorClassifications.swift
//  GooglePlacesSearch
//
//  Created by Himanshi Bhardwaj on 8/27/17.
//  Copyright © 2017 Himanshi Bhardwaj. All rights reserved.
//

extension Error {
    public var errorString: String {
        switch self.localizedDescription {
        case "The Internet connection appears to be offline." :
            return "Your Internet connection appears to be offline. Please try again once you are back online."
        case "ZERO_RESULTS" :
            return "No results found with that search."
        default:
            return "Oops! Something wrong happened. Please try again."
        }
    }
}
