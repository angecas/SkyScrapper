//
//  HomeViewModel.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 01/12/2024.
//

import Foundation
import CoreLocation
import Combine

// MARK: - AirportData Model
struct AirportData: Codable {
    var airport: AirportInfo
}

// MARK: - Airport Model
struct AirportInfo: Codable {
    let iata: String?
    let name: String
    let city: String
    let state: String
    let country: String
    let elevation: Int
    let lat: Double
    let lon: Double
    let tz: String
}

class HomeViewModel: NSObject {
    
    @Published private(set) var aiports: (origin: [AirportData], depart:  [AirportData]) = (origin: [], depart: [])
    @Published var selectedAiports: (origin: AirportData?, depart:  AirportData?) = (origin: nil, depart: nil)
    @Published var selectedDates: [Date?] = []

    private var originalAirports: [AirportData] = []
    
    private let locationManager: CLLocationManager
    var currentLocation: CLLocation?
    
    var flightParameters = SearchFlightsParameters()
    private var serpApiManager: SerpApiManager = SerpApiManager()
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func searchFlights() {
        guard let departureId = selectedAiports.origin?.airport.iata else {return}
        guard let arrivalIdId = selectedAiports.depart?.airport.iata else {return}
        
        self.flightParameters.departureId = departureId
        self.flightParameters.arrivalId = arrivalIdId
        Task {
            await serpApiManager.searchFlightsRequest(parameters: flightParameters)
        }
        
    }
    
    func fetchNearbyAirports() {
        guard let currentLocation = currentLocation else { return }
        
        let nearbyAirports = originalAirports.filter { airportData in
            //        let nearbyAirports = airports.filter { airportData in
            let airportLocation = CLLocation(latitude: airportData.airport.lat, longitude: airportData.airport.lon)
            return airportLocation.distance(from: currentLocation) < 50000 // Within 50 km
        }
        print("Nearby Airports: \(nearbyAirports.map { $0.airport.name })")
    }
    
    func fetchAirportData() {
        if let airportData = loadMockData(for: "airports", ofType: [AirportData].self) {
            originalAirports = airportData.filter { $0.airport.iata != nil && !$0.airport.iata!.isEmpty }
//            originAirports = originalAirports
//            departAirports = originalAirports
            aiports = (origin: originalAirports, depart: originalAirports)
        }
    }
    
    func filterOriginAirportData(by query: String?) {
        guard let query = query, !query.isEmpty else {
            aiports.origin = originalAirports
            return
        }
        
        let lowercasedQuery = query.lowercased()
        
        let exactMatches = originalAirports.filter { airportData in
            airportData.airport.iata?.lowercased() == lowercasedQuery
        }
        
        let otherMatches = originalAirports.filter { airportData in
            let cityMatches = airportData.airport.city.lowercased().contains(lowercasedQuery)
            let iataMatches = airportData.airport.iata?.lowercased().contains(lowercasedQuery) ?? false
            let countryMatches = airportData.airport.country.lowercased().contains(lowercasedQuery)
            let aiportMatches = airportData.airport.name.lowercased().contains(lowercasedQuery)
            return (cityMatches || iataMatches || countryMatches || aiportMatches) &&
            !(airportData.airport.iata?.lowercased() == lowercasedQuery)
        }
        
        let sortedOtherMatches = otherMatches.sorted {
            $0.airport.city.lowercased() < $1.airport.city.lowercased()
        }
        if (exactMatches + sortedOtherMatches).isEmpty {
            aiports.origin = originalAirports
        } else {
            aiports.origin = exactMatches + sortedOtherMatches
        }
    }
    
    func filterDepartAirportData(by query: String?) {
        guard let query = query, !query.isEmpty else {
            aiports.depart = originalAirports
            return
        }
        
        let lowercasedQuery = query.lowercased()
        
        let exactMatches = originalAirports.filter { airportData in
            airportData.airport.iata?.lowercased() == lowercasedQuery
        }
        
        let otherMatches = originalAirports.filter { airportData in
            let cityMatches = airportData.airport.city.lowercased().contains(lowercasedQuery)
            let iataMatches = airportData.airport.iata?.lowercased().contains(lowercasedQuery) ?? false
            let countryMatches = airportData.airport.country.lowercased().contains(lowercasedQuery)
            let aiportMatches = airportData.airport.name.lowercased().contains(lowercasedQuery)
            return (cityMatches || iataMatches || countryMatches || aiportMatches) &&
            !(airportData.airport.iata?.lowercased() == lowercasedQuery)
        }
        
        let sortedOtherMatches = otherMatches.sorted {
            $0.airport.city.lowercased() < $1.airport.city.lowercased()
        }
        if (exactMatches + sortedOtherMatches).isEmpty {
            aiports.depart = originalAirports
        } else {
            aiports.depart = exactMatches + sortedOtherMatches
            
        }
    }

    func setDateParameter() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
                
        if let departDate = selectedDates.first {
            flightParameters.outboundDate = dateFormatter.string(from: departDate!)
        }
        
        if let arrivalDate = selectedDates.last {
            flightParameters.returnDate = dateFormatter.string(from: arrivalDate!)
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


extension HomeViewModel: CLLocationManagerDelegate {
    
    // MARK: - CLLocationManagerDelegate Methods
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied or restricted.")
        case .notDetermined:
            print("Authorization status not determined yet.")
        @unknown default:
            print("Unknown authorization status.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        print("Current Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        fetchNearbyAirports()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
}
