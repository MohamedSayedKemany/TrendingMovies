//
//  MovieDetailsViewModelTests.swift
//  TrendingMoviesTests
//
//  Created by Mohamed Sayed on 02/10/2024.
//

import XCTest
import Combine
@testable import TrendingMovies

class MovieDetailsViewModelTests: XCTestCase {
    
    var mockNetworkService: MockMovieDetailsNetworkService!
    var mockCachingManager: MockCachingManager!
    var viewModel: MovieDetailsViewModel!
    let movieId = 957452
    var testMovieDetailsJSON: Data!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNetworkService = MockMovieDetailsNetworkService()
        mockCachingManager = MockCachingManager()
        viewModel = MovieDetailsViewModel(networkService: mockNetworkService, cachingManager: mockCachingManager, movieId: movieId)
        testMovieDetailsJSON = readJSONStringFromFile(fileName: "MovieDetailsResponse", bundleFor: MovieDetailsViewModelTests.self)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockNetworkService = nil
        viewModel = nil
        testMovieDetailsJSON = nil
    }
    
    func testFetchMovieDetails_NetworkSuccess_NoCache() {
        // Given
        let expectation = self.expectation(description: "Waiting for fetch completion")
        
        let mockMovieData = try! JSONDecoder().decode(MovieDetails.self, from: Data(testMovieDetailsJSON))
        mockNetworkService.mockResponse = mockMovieData

        // When
        viewModel.fetchMovieDetails(movieId: movieId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            
            // Then
            XCTAssertEqual(self.viewModel.movie?.adult, mockMovieData.adult)
            XCTAssertFalse(self.viewModel.isLoading)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testFetchMovieDetails_NetworkSuccess_WithCache() {
        // Given
        let expectation = self.expectation(description: "Waiting for fetch completion")
        
        let mockMovieData = try! JSONDecoder().decode(MovieDetails.self, from: Data(testMovieDetailsJSON))
        mockNetworkService.mockResponse = mockMovieData
        mockCachingManager.mockCachedData = mockMovieData
        
        // When
        viewModel.fetchMovieDetails(movieId: movieId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            
            // Then
            XCTAssertEqual(self.viewModel.movie?.adult, mockMovieData.adult)
            XCTAssertFalse(self.viewModel.isLoading)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testFetchMovieDetails_NetworkFailure() {
        // Given
        let expectation = self.expectation(description: "Waiting for fetch completion")
        
        mockNetworkService.mockError = NetworkError.invalidURL
        
        // When
        viewModel.fetchMovieDetails(movieId: movieId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            
            // Then
            XCTAssertNil(self.viewModel.movie)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNotNil(self.viewModel.error)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testFetchMovieDetails_InvalidMovieId() {
        // Given
        let expectation = self.expectation(description: "Waiting for fetch completion")
        
        mockNetworkService.mockError = NetworkError.invalidURL
        
        // When
        viewModel.fetchMovieDetails(movieId: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            
            // Then
            XCTAssertNil(self.viewModel.movie)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNotNil(self.viewModel.error)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 2)
    }
}
