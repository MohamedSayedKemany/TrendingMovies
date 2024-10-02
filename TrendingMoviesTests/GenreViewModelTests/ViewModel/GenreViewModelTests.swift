//
//  GenreViewModelTests.swift
//  TrendingMoviesTests
//
//  Created by Mohamed Sayed on 02/10/2024.
//

import XCTest
import Combine
@testable import TrendingMovies

class GenreViewModelTests: XCTestCase {

    var mockNetworkService: MockGenresNetworkService!
    var viewModel: GenreViewModel!
    var testGenresJSON: Data!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNetworkService = MockGenresNetworkService()
        viewModel = GenreViewModel(networkService: mockNetworkService)
        testGenresJSON = readJSONStringFromFile(fileName: "GenresResponse", bundleFor: GenreViewModelTests.self)
    }
    
    override func tearDownWithError() throws {
           try super.tearDownWithError()
        mockNetworkService = nil
        viewModel = nil
        testGenresJSON = nil
       }

    func testFetchGenresSuccess() {
        let mockGenresData = try! JSONDecoder().decode(Genres.self, from: Data(testGenresJSON))
        mockNetworkService.mockResponse = mockGenresData

        let expectation = self.expectation(description: "Waiting for fetch completion")

        viewModel.fetchGenres()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            XCTAssertEqual(self.viewModel.genres.count, mockGenresData.genres.count)
            XCTAssertNil(self.viewModel.error)
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 5)
    }

    func testFetchGenresFailure() {
        mockNetworkService.mockError = NetworkError.invalidURL

        let expectation = self.expectation(description: "Waiting for fetch completion")

        viewModel.fetchGenres()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            XCTAssertEqual(self.viewModel.genres.isEmpty, true)
            XCTAssertNotNil(self.viewModel.error)
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 5)
    }
}
