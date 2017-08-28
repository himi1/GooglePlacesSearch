//
//  GooglePlacesRequest.swift
//  GooglePlacesSearch
//
//  Created by Himanshi Bhardwaj on 8/27/17.
//  Copyright © 2017 Himanshi Bhardwaj. All rights reserved.
//

import Foundation

class GooglePlacesRequest {
    //--------------------------------------
    // MARK: Typealias
    //--------------------------------------
    
    typealias JSON = [String: Any]
    
    
    //--------------------------------------
    // MARK: Functions
    //--------------------------------------
    
    private class func query(_ parameters: [String: String]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sorted(by: <) {
            let value = parameters[key]!
            components += [(escape(key), escape("\(value)"))]
        }
        
        return (components.map{"\($0)=\($1)"} as [String]).joined(separator: "&")
    }
    
    private class func escape(_ string: String) -> String {
        let generalDelimiters = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimiters = "!$&'()*+,;="
        
        let legalURLCharactersToBeEscaped = (generalDelimiters + subDelimiters)
        
        let allowedCharacters = CharacterSet.init(charactersIn: legalURLCharactersToBeEscaped).inverted;
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
    }
    
    open class func doRequest(_ url: String, params: [String: String], completion: @escaping (JSON?,Error?) -> ()) {
        let request = URLRequest(
            url: URL(string: "\(url)?\(query(params))")!
        )
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request){ data, response, error in
            self.handleResponse(data, response: response , error: error, completion: completion)
        }
        
        task.resume()
    }
    
    private class func handleResponse(_ data: Data?, response: URLResponse?, error: Error?, completion: @escaping (JSON?, Error?) -> ()) {
        let done: ((JSON?, Error?) -> Void) = {(json, error) in
            DispatchQueue.main.async(execute: {
                completion(json,error)
            })
        }
        
        if let error = error {
            print("GooglePlaces Error: \(error.localizedDescription)")
            done(nil,error)
            return
        }
        
        if response == nil {
            print("GooglePlaces Error: No response from API")
            let error = NSError(domain: "GooglePlacesAutocompleteErrorDomain"
                , code: 1001, userInfo: [NSLocalizedDescriptionKey:"No response from API"])
            done(nil,error)
            return
        }
        
        let httpResponse = response as! HTTPURLResponse
        
        
        if httpResponse.statusCode != 200 {
            print("GooglePlaces Error: Invalid status code \(httpResponse.statusCode) from API")
            let error = NSError(domain: "GooglePlacesAutocompleteErrorDomain"
                , code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey:"Invalid status code"])
            done(nil,error)
            return
        }
        
        let json: NSDictionary?
        do {
            json = try JSONSerialization.jsonObject(
                with: data!,
                options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
        } catch {
            print("Serialisation error")
            let serialisationError = NSError(domain: "GooglePlacesAutocompleteErrorDomain"
                , code: 1002, userInfo: [NSLocalizedDescriptionKey:"Serialization error"])
            done(nil,serialisationError)
            return
        }
        
        if let status = json?["status"] as? String {
            if status != "OK" {
                print("GooglePlaces API Error: \(status)")
                let error = NSError(domain: "GooglePlacesAutocompleteErrorDomain"
                    , code: 1002, userInfo: [NSLocalizedDescriptionKey:status])
                done(nil,error)
                return
            }
        }
        done(json as? [String:Any],nil)
    }
}

