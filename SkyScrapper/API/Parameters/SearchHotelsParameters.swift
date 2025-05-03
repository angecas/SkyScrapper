//
//  SearchHotelsParameters.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 13/06/2024.
//

import Foundation

struct SearchHotelsParameters {
    var apiKey: String = SecretKeys.API_KEY

    var gl: String?
    var hl: String?
    var currency: String?
    
    var q: String?
    var checkInDate: String
    var checkOutDate: String
    var adults: String?
    var children: String?
    var childrenAges: String?
    var sortBy: String?
    var minPrice: String?
    var maxPrice: String?
    var propertyTypes: String?
    var amenities: String?
    var rating: String?
    var brands: String?
    var hotelClass: String?
    var freeCancellation: String?
    var specialOffers: String?
    var ecoCertified: String?
    var engine: String = "google_hotels"
    
    func toDictionary() -> [String: String] {
            var dict: [String: String] = [:]
            
            dict["engine"] = engine
            dict["api_key"] = apiKey
            dict["check_in_date"] = checkInDate
            dict["check_out_date"] = checkOutDate

            if let gl = gl {
                dict["gl"] = gl
            }
            if let hl = hl {
                dict["hl"] = hl
            }
            if let currency = currency {
                dict["currency"] = currency
            }
            if let adults = adults {
                dict["adults"] = adults
            }
            
            if let children = children {
                dict["children"] = children
            }
            if let childrenAges = childrenAges {
                dict["children_ages"] = childrenAges
            }
            if let sortBy = sortBy {
                dict["sort_by"] = sortBy
            }
            if let minPrice = minPrice {
                dict["min_price"] = minPrice
            }
            if let maxPrice = maxPrice {
                dict["max_price"] = maxPrice
            }
            if let propertyTypes = propertyTypes {
                dict["property_types"] = propertyTypes
            }
            if let amenities = amenities {
                dict["amenities"] = amenities
            }
            if let rating = rating {
                dict["rating"] = rating
            }
            if let brands = brands {
                dict["brands"] = brands
            }
            if let hotelClass = hotelClass {
                dict["hotel_class"] = hotelClass
            }
            if let freeCancellation = freeCancellation {
                dict["free_cancellation"] = freeCancellation
            }
            
            if let specialOffers = specialOffers {
                dict["special_offers"] = specialOffers
            }
            if let ecoCertified = ecoCertified {
                dict["eco_certified"] = ecoCertified
            }
            
            return dict
        }
    
}
