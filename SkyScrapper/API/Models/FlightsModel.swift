//
//  FlightsModel.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 10/06/2024.
//

import Foundation

import Foundation

// MARK: - GoogleFlight
struct FlightsModel: Codable {
    let searchMetadata: SearchFlightMetadata?
    let searchParameters: SearchFlightParameters?
    let bestFlights, otherFlights: [Flight]?
    let priceInsights: PriceInsights?
    let airports: [AirportModel]?

    enum CodingKeys: String, CodingKey {
        case searchMetadata = "search_metadata"
        case searchParameters = "search_parameters"
        case bestFlights = "best_flights"
        case otherFlights = "other_flights"
        case priceInsights = "price_insights"
        case airports = "airports"
    }
}

// MARK: - Flight
struct Flight: Codable {
    let flights: [FlightElement]
    let layovers: [Layover]
    let totalDuration: Int
    let carbonEmissions: CarbonEmissions
    let price: Int
    let type: TypeEnum
    let airlineLogo: String
    let extensions: [String]
    let departureToken: String

    enum CodingKeys: String, CodingKey {
        case flights, layovers
        case totalDuration = "total_duration"
        case carbonEmissions = "carbon_emissions"
        case price, type
        case airlineLogo = "airline_logo"
        case extensions
        case departureToken = "departure_token"
    }
}

// MARK: - CarbonEmissions
struct CarbonEmissions: Codable {
    let thisFlight, typicalForThisRoute, differencePercent: Int

    enum CodingKeys: String, CodingKey {
        case thisFlight = "this_flight"
        case typicalForThisRoute = "typical_for_this_route"
        case differencePercent = "difference_percent"
    }
}

// MARK: - FlightElement
struct FlightElement: Codable {
    let departureAirport, arrivalAirport: Airport
    let duration: Int
    let airplane, airline: String
    let airlineLogo: String
    let travelClass: TravelClass
    let flightNumber: String
    let legroom: Legroom
    let extensions: [String]
    let oftenDelayedByOver30_Min: Bool?
    let ticketAlsoSoldBy: [String]?

    enum CodingKeys: String, CodingKey {
        case departureAirport = "departure_airport"
        case arrivalAirport = "arrival_airport"
        case duration, airplane, airline
        case airlineLogo = "airline_logo"
        case travelClass = "travel_class"
        case flightNumber = "flight_number"
        case legroom, extensions
        case oftenDelayedByOver30_Min = "often_delayed_by_over_30_min"
        case ticketAlsoSoldBy = "ticket_also_sold_by"
    }
}

// MARK: - Airport
struct Airport: Codable {
    let name, id, time: String
}

enum Legroom: String, Codable {
    case the30In = "30 in"
    case the31In = "31 in"
}

enum TravelClass: String, Codable {
    case economy = "Economy"
}

// MARK: - Layover
struct Layover: Codable {
    let duration: Int
    let name, id: String
}

enum TypeEnum: String, Codable {
    case roundTrip = "Round trip"
}

// MARK: - PriceInsights
struct PriceInsights: Codable {
    let lowestPrice: Int
    let priceLevel: String
    let typicalPriceRange: [Int]
    let priceHistory: [[Int]]

    enum CodingKeys: String, CodingKey {
        case lowestPrice = "lowest_price"
        case priceLevel = "price_level"
        case typicalPriceRange = "typical_price_range"
        case priceHistory = "price_history"
    }
}

// MARK: - SearchMetadata
struct SearchFlightMetadata: Codable {
    let id, status: String?
    let jsonEndpoint: String?
    let createdAt, processedAt: String?
    let googleFlightsURL: String?
    let rawHTMLFile: String?
    let prettifyHTMLFile: String?
    let totalTimeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case id, status
        case jsonEndpoint = "json_endpoint"
        case createdAt = "created_at"
        case processedAt = "processed_at"
        case googleFlightsURL = "google_flights_url"
        case rawHTMLFile = "raw_html_file"
        case prettifyHTMLFile = "prettify_html_file"
        case totalTimeTaken = "total_time_taken"
    }
}

// MARK: - SearchParameters
struct SearchFlightParameters: Codable {
    let engine, hl, gl, departureID: String?
    let arrivalID, outboundDate, returnDate: String?

    enum CodingKeys: String, CodingKey {
        case engine, hl, gl
        case departureID = "departure_id"
        case arrivalID = "arrival_id"
        case outboundDate = "outbound_date"
        case returnDate = "return_date"
    }
}

struct AirportModel: Codable {
    let departure: [AirportDetails]?
    let arrival: [AirportDetails]?
}

struct AirportDetails: Codable {
    let airport: AirportInfoModel?
    let city: String?
    let country: String?
    let countryCode: String?
    let image: String?
    let thumbnail: String?
}

struct AirportInfoModel: Codable {
    let id: String?
    let name: String?
}
