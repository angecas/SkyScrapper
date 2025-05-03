//
//  GoogleFlightsApi.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 09/06/2024.
//

import Foundation

enum SerpApi {
    case searchFlights(parameters: SearchFlightsParameters)
    case searchHotels(parameters: SearchHotelsParameters)
}

extension SerpApi: EndPoint {
    var path: String {
        return "https://serpapi.com/search"
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var header: [String : String]? {
        return nil
    }
    
    var body: [String : String]? {
        return nil
    }
    
    var host: String {
        return "serpapi.com"
    }
    
    var queryParams: [String : String]? {
        switch self {
        case .searchFlights(let parameters):
            return parameters.toDictionary()
        case .searchHotels(let parameters):
            return parameters.toDictionary()
        }
    }
    
    var pathParams: [String : String]? {
        return nil
    }
}
