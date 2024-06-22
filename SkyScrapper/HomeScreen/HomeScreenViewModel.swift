//
//  HomeScreenViewModel.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 13/06/2024.
//

import Foundation

class HomeScreenViewModel: ObservableObject {
    
    let manager: SerpApiManagerProtocol
    @Published var flights: FlightData?
    @Published var hotels: HotelsModel?
    
    init(manager: SerpApiManagerProtocol = SerpApiManager()) {
        self.manager = manager
    }
    
    func fetchFlightsData(parameters: SearchFlightsParameters) {
        Task(priority: .background) {
            flights = await manager.searchFlightsRequest(parameters: parameters)
        }
    }
}
