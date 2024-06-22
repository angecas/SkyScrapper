//
//  SearchFlightsParameters.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 10/06/2024.
//

import Foundation
struct SearchFlightsParameters {
    var apiKey: String = SecretKeys.API_KEY

    var gl: String?
    var hl: String?
    var currency: String?

    var departureId: String
    var arrivalId: String
    var type: String?
    var outboundDate: String
    var returnDate: String?
    var travelClass: String?
    var showHidden: String?
    var adults: String?
    var children: String?
    var infantsInSeat: String?
    var infantsOnLap: String?
    var stops: String?
    var excludeAirlines: String?
    var includeAirlines: String?
    var bags: String?
    var maxPrice: String?
    var outboundTimes: String?
    var returnTimes: String?
    var emissions: String?
    var layoverDuration: String?
    var excludeConns: String?
    var maxDuration: String?
    var departureToken: String?
    var bookingToken: String?
        
    var engine: String = "google_flights"
    
    func toDictionary() -> [String: String] {
            var dict: [String: String] = [:]
            
            dict["engine"] = engine
            dict["api_key"] = apiKey
            dict["departure_id"] = departureId
            dict["arrival_id"] = arrivalId
            if let gl = gl {
                dict["gl"] = gl
            }
            if let hl = hl {
                dict["hl"] = hl
            }
            if let currency = currency {
                dict["currency"] = currency
            }
            if let type = type {
                dict["type"] = type
            }
            dict["outbound_date"] = outboundDate
            if let returnDate = returnDate {
                dict["return_date"] = returnDate
            }
            if let travelClass = travelClass {
                dict["travel_class"] = travelClass
            }
            if let showHidden = showHidden {
                dict["show_hidden"] = showHidden
            }
            if let adults = adults {
                dict["adults"] = adults
            }
            if let children = children {
                dict["children"] = children
            }
            if let infantsInSeat = infantsInSeat {
                dict["infants_in_seat"] = infantsInSeat
            }
            if let infantsOnLap = infantsOnLap {
                dict["infants_on_lap"] = infantsOnLap
            }
            if let stops = stops {
                dict["stops"] = stops
            }
            if let excludeAirlines = excludeAirlines {
                dict["exclude_airlines"] = excludeAirlines
            }
            if let includeAirlines = includeAirlines {
                dict["include_airlines"] = includeAirlines
            }
            if let bags = bags {
                dict["bags"] = bags
            }
            
            if let maxPrice = maxPrice {
                dict["max_price"] = maxPrice
            }
            
            if let outboundTimes = outboundTimes {
                dict["outbound_times"] = outboundTimes
            }
            if let returnTimes = returnTimes {
                dict["return_times"] = returnTimes
            }
            if let emissions = emissions {
                dict["emissions"] = emissions
            }
            
            if let layoverDuration = layoverDuration {
                dict["layover_duration"] = layoverDuration
            }
            if let excludeConns = excludeConns {
                dict["exclude_conns"] = excludeConns
            }
            
            if let maxDuration = maxDuration {
                dict["max_duration"] = maxDuration
            }
            
            if let departureToken = departureToken {
                dict["departure_token"] = departureToken
            }
            if let bookingToken = bookingToken {
                dict["booking_token"] = bookingToken
            }
            
            return dict
        }
    
}
