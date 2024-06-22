//
//  MockSerpApiManager.swift
//  SkyScrapperTests
//
//  Created by Angélica Rodrigues on 18/06/2024.
//

import Foundation
@testable import SkyScrapper

class MockSerpApiManager: SerpApiManagerProtocol {
    var fetchWithError: Bool = false
    
    func searchFlightsRequest(parameters: SkyScrapper.SearchFlightsParameters) async -> SkyScrapper.FlightData {
        if !fetchWithError {
            let flightData = loadMockData(for: "GoogleFlightMock", ofType: FlightsModel.self)
            return FlightData(data: flightData, error: nil)
        } else {
            return FlightData(data: nil, error: .generic)
        }
    }
    
    func searchHotelsRequest(parameters: SkyScrapper.SearchHotelsParameters) async -> SkyScrapper.HotelData {
        if fetchWithError {
            return HotelData(data: nil, error: .generic)
        } else {
            return HotelData(data: nil, error: nil)
        }
    }
    
    func loadMockData<T: Codable>(for resource: String, ofType type: T.Type) -> T?  {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json") else {
            print("Failed to locate \(resource) in bundle.")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let mockData = try decoder.decode(T.self, from: data)
            return mockData
        } catch {
            print("Failed to decode MockData.json: \(error)")
            return nil
        }
    }
}
