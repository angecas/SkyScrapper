//
//  HomeScreenViewModelTests.swift
//  SkyScrapperTests
//
//  Created by Angélica Rodrigues on 17/06/2024.
//

import Foundation
import Combine
import XCTest
@testable import SkyScrapper

final class HomeScreenViewModelTests: XCTestCase {

    var params: SearchFlightsParameters!
    var manager: MockSerpApiManager!
    var viewModel: HomeScreenViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        params = SearchFlightsParameters(departureId: "CDG", arrivalId: "AUS", outboundDate: "2024-08-11", returnDate: "2024-09-11")
        manager = MockSerpApiManager()
        viewModel = HomeScreenViewModel(manager: manager)
        cancellables = []

    }

    override func tearDownWithError() throws {
        params = nil
        manager = nil
        viewModel = nil
    }

    func testFetchFlightsData_Successful() throws {
        let expectation = XCTestExpectation(description: "Fetch flights data succesfull")
        viewModel.fetchFlightsData(parameters: params)

        viewModel.$flights
            .dropFirst()
            .sink { flights in
                XCTAssertNil(flights?.error)
                XCTAssertNotNil(flights?.data)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchFlightsData_WithError() throws {
        let expectation = XCTestExpectation(description: "Fetch flights data with error")
        manager.fetchWithError = true

        viewModel.fetchFlightsData(parameters: params)
        
        viewModel.$flights
            .dropFirst()
            .sink { flights in
                XCTAssertNotNil(flights?.error)
                XCTAssertNil(flights?.data)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
}
