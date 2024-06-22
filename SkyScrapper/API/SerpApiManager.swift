//
//  GoogleFlightsManager.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 10/06/2024.
//

import Foundation

enum DataType {
    case flights
    case hotels
}

protocol SerpApiManagerProtocol {
    func searchFlightsRequest(parameters: SearchFlightsParameters) async -> FlightData
    func searchHotelsRequest(parameters: SearchHotelsParameters) async -> HotelData
}

typealias FlightData = (data: FlightsModel?, error: NetworkError?)
typealias HotelData = (data: HotelsModel?, error: NetworkError?)

final class SerpApiManager: SerpApiManagerProtocol {
    @Published var callError: String = String()
    private var networkService: Networkable
    
    init(networkService: Networkable = NetworkService()) {
        self.networkService = networkService
    }
    
    func searchFlightsRequest(parameters: SearchFlightsParameters) async -> FlightData {
        do {
            let flights = try await networkService.sendRequest(endpoint: SerpApi.searchFlights(parameters: parameters)) as FlightsModel
            return FlightData(data: flights, error: nil)
        } catch {
            guard let error = error as? NetworkError else {
                return FlightData(data: nil, error: nil)
            }
            return FlightData(data: nil, error: error)

        }
    }

    func searchHotelsRequest(parameters: SearchHotelsParameters) async -> HotelData {
        do {
            let hotels = try await networkService.sendRequest(endpoint: SerpApi.searchHotels(parameters: parameters)) as HotelsModel
            return HotelData(data: hotels, error: nil)
        } catch {
            guard let error = error as? NetworkError else {
                return HotelData(data: nil, error: nil)
            }
            return HotelData(data: nil, error: error)
        }
    }
}
