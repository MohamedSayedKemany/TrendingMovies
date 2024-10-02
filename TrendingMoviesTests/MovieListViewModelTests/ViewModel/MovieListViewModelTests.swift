//
//  MovieListViewModelTests.swift
//  TrendingMoviesTests
//
//  Created by Mohamed Sayed on 01/10/2024.
//

import XCTest
import Combine
@testable import TrendingMovies

class MovieListViewModelTests: XCTestCase {
    var testMovieJSON: Data!
    var mockNetworkService: MockMoviesListNetworkService!
    var mockCachingManager: MockMovieListCachingManager!
    var viewModel: MovieListViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNetworkService = MockMoviesListNetworkService()
        mockCachingManager = MockMovieListCachingManager()
        viewModel = MovieListViewModel(networkService: mockNetworkService)
        testMovieJSON = readJSONStringFromFile(fileName: "MoviesResponse", bundleFor: MovieListViewModelTests.self)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockNetworkService = nil
        mockCachingManager = nil
        viewModel = nil
        testMovieJSON = nil
    }
    
    func testFetchMoviesSuccess() {
        //Given
        let mockMovieData = try! JSONDecoder().decode(MovieResponse.self, from: testMovieJSON!)
        mockNetworkService.mockResponse = mockMovieData
        
        let expectation = self.expectation(description: "Waiting for fetch completion")
        
        //When
        viewModel.fetchMovies(page: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            
            //Then
            XCTAssertEqual(self.viewModel.movies.count, mockMovieData.results.count)
            XCTAssertEqual(self.viewModel.isLoading, false)
            XCTAssertNil(self.viewModel.error)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testFetchMoviesFailure() {
        //Given
        mockNetworkService.mockError = NetworkError.invalidURL
        let expectation = self.expectation(description: "Waiting for fetch completion")
        
        // When
        viewModel.fetchMovies(page: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            
            //Then
            XCTAssertEqual(self.viewModel.movies.isEmpty, true)
            XCTAssertEqual(self.viewModel.isLoading, false)
            XCTAssertNotNil(self.viewModel.error)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testFetchMoreMovies() {
        //Given
        let initialMovieData = try! JSONDecoder().decode(MovieResponse.self, from: Data(testMovieJSON!))
        mockNetworkService.mockResponse = initialMovieData
        viewModel.fetchMovies(page: 1)
        
        let expectation = self.expectation(description: "Waiting for fetch more completion")
        
        // When
        viewModel.fetchMoreMovies()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            
            //Then
            XCTAssertEqual(self.viewModel.movies.count, initialMovieData.results.count)
            XCTAssertEqual(self.viewModel.isLoadingMore, false)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testFilteredMovies() {
        //Given
        let mockMovieData = try! JSONDecoder().decode(MovieResponse.self, from: Data(testMovieJSON!))
        mockNetworkService.mockResponse = mockMovieData
        viewModel.fetchMovies(page: 1)
        
        // When
        viewModel.searchText = "action"
        viewModel.selectedGenres = [80]
        
        // Then
        XCTAssertEqual(self.viewModel.filteredMovies.count, mockMovieData.results.filter { $0.title.lowercased().contains("action") }.count)
        XCTAssertEqual(self.viewModel.filteredMovies.count, mockMovieData.results.filter { $0.title.lowercased().contains("action") && $0.genreIDS.contains(80) }.count)
    }
    
    func testFetchMovies_NetworkSuccess_WithCache() {
        // Given
        let expectation = self.expectation(description: "Waiting for fetch completion")
        
        let mockMovieData = try! JSONDecoder().decode(MovieResponse.self, from: Data(testMovieJSON))
        mockNetworkService.mockResponse = mockMovieData
        mockCachingManager.mockCachedData = mockMovieData
        
        // When
        viewModel.fetchMovies(page: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            
            // Then
            XCTAssertFalse(self.viewModel.movies.isEmpty)
            XCTAssertEqual(self.viewModel.movies.count, mockMovieData.results.count)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNil(self.viewModel.error)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 2)
    }
}
