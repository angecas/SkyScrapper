//
//  HotelsModel.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 13/06/2024.
//

import Foundation

// MARK: - GoogleHotel
struct HotelsModel: Codable {
    let searchMetadata: SearchHotelMetadata
    let searchParameters: SearchHotelParameters
    let brands: [Brand]
    let properties: [Property]
    let serpapiPagination: SerpapiPagination

    enum CodingKeys: String, CodingKey {
        case searchMetadata = "search_metadata"
        case searchParameters = "search_parameters"
        case brands, properties
        case serpapiPagination = "serpapi_pagination"
    }
}

// MARK: - Brand
struct Brand: Codable {
    let id: Int
    let name: String
    let children: [Child]?
}

// MARK: - Child
struct Child: Codable {
    let id: Int
    let name: String
}

// MARK: - Property
struct Property: Codable {
    let type: PropertyType
    let name: String
    let link: String?
    let gpsCoordinates: GpsCoordinates
    let checkInTime: CheckInTime
    let checkOutTime: CheckOutTime?
    let ratePerNight, totalRate: RatePerNight
    let prices: [Price]?
    let nearbyPlaces: [NearbyPlace]
    let images: [Image]
    let overallRating: Double
    let reviews: Int
    let locationRating: Double
    let amenities: [String]
    let excludedAmenities, essentialInfo: [String]?
    let propertyToken: String
    let serpapiPropertyDetailsLink: String
    let description: String?
    let hotelClass: HotelClass?
    let extractedHotelClass: Int?
    let ratings: [Rating]?
    let reviewsBreakdown: [ReviewsBreakdown]?
    let ecoCertified: Bool?

    enum CodingKeys: String, CodingKey {
        case type, name, link
        case gpsCoordinates = "gps_coordinates"
        case checkInTime = "check_in_time"
        case checkOutTime = "check_out_time"
        case ratePerNight = "rate_per_night"
        case totalRate = "total_rate"
        case prices
        case nearbyPlaces = "nearby_places"
        case images
        case overallRating = "overall_rating"
        case reviews
        case locationRating = "location_rating"
        case amenities
        case excludedAmenities = "excluded_amenities"
        case essentialInfo = "essential_info"
        case propertyToken = "property_token"
        case serpapiPropertyDetailsLink = "serpapi_property_details_link"
        case description
        case hotelClass = "hotel_class"
        case extractedHotelClass = "extracted_hotel_class"
        case ratings
        case reviewsBreakdown = "reviews_breakdown"
        case ecoCertified = "eco_certified"
    }
}

enum CheckInTime: String, Codable {
    case the100Pm = "1:00 PM"
    case the200Pm = "2:00 PM"
    case the300Pm = "3:00 PM"
}

enum CheckOutTime: String, Codable {
    case the1100Am = "11:00 AM"
    case the1200Pm = "12:00 PM"
}

// MARK: - GpsCoordinates
struct GpsCoordinates: Codable {
    let latitude, longitude: Double
}

enum HotelClass: String, Codable {
    case the4StarHotel = "4-star hotel"
    case the5StarHotel = "5-star hotel"
}

// MARK: - Image
struct Image: Codable {
    let thumbnail: String
    let originalImage: String

    enum CodingKeys: String, CodingKey {
        case thumbnail
        case originalImage = "original_image"
    }
}

// MARK: - NearbyPlace
struct NearbyPlace: Codable {
    let name: String
    let transportations: [Transportation]?
}

// MARK: - Transportation
struct Transportation: Codable {
    let type: TransportationType
    let duration: String
}

enum TransportationType: String, Codable {
    case publicTransport = "Public transport"
    case taxi = "Taxi"
    case walking = "Walking"
}

// MARK: - Price
struct Price: Codable {
    let source: String
    let logo: String
    let numGuests: Int
    let ratePerNight: RatePerNight
    let official: Bool?

    enum CodingKeys: String, CodingKey {
        case source, logo
        case numGuests = "num_guests"
        case ratePerNight = "rate_per_night"
        case official
    }
}

// MARK: - RatePerNight
struct RatePerNight: Codable {
    let lowest: String
    let extractedLowest: Int
    let beforeTaxesFees: String
    let extractedBeforeTaxesFees: Int

    enum CodingKeys: String, CodingKey {
        case lowest
        case extractedLowest = "extracted_lowest"
        case beforeTaxesFees = "before_taxes_fees"
        case extractedBeforeTaxesFees = "extracted_before_taxes_fees"
    }
}

// MARK: - Rating
struct Rating: Codable {
    let stars, count: Int
}

// MARK: - ReviewsBreakdown
struct ReviewsBreakdown: Codable {
    let name, description: String
    let totalMentioned, positive, negative, neutral: Int

    enum CodingKeys: String, CodingKey {
        case name, description
        case totalMentioned = "total_mentioned"
        case positive, negative, neutral
    }
}

enum PropertyType: String, Codable {
    case hotel = "hotel"
    case vacationRental = "vacation rental"
}

// MARK: - SearchMetadata
struct SearchHotelMetadata: Codable {
    let id, status: String
    let jsonEndpoint: String
    let createdAt, processedAt: String
    let googleHotelsURL: String
    let rawHTMLFile: String
    let prettifyHTMLFile: String
    let totalTimeTaken: Double

    enum CodingKeys: String, CodingKey {
        case id, status
        case jsonEndpoint = "json_endpoint"
        case createdAt = "created_at"
        case processedAt = "processed_at"
        case googleHotelsURL = "google_hotels_url"
        case rawHTMLFile = "raw_html_file"
        case prettifyHTMLFile = "prettify_html_file"
        case totalTimeTaken = "total_time_taken"
    }
}

// MARK: - SearchParameters
struct SearchHotelParameters: Codable {
    let engine, q, gl, hl: String
    let currency, checkInDate, checkOutDate: String
    let adults, children: Int

    enum CodingKeys: String, CodingKey {
        case engine, q, gl, hl, currency
        case checkInDate = "check_in_date"
        case checkOutDate = "check_out_date"
        case adults, children
    }
}

// MARK: - SerpapiPagination
struct SerpapiPagination: Codable {
    let currentFrom, currentTo: Int
    let nextPageToken: String
    let next: String

    enum CodingKeys: String, CodingKey {
        case currentFrom = "current_from"
        case currentTo = "current_to"
        case nextPageToken = "next_page_token"
        case next
    }
}
