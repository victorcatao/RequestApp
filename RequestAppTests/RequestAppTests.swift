//
//  RequestAppTests.swift
//  RequestAppTests
//
//  Created by Victor Catão on 22/01/22.
//

import XCTest
@testable import RequestApp

class RequestAppTests: XCTestCase {

    func testMoviesServiceMock() async {
        let serviceMock = MoviesServiceMock()
        do {
            let failingResult = try await serviceMock.getMovieDetail(id: 0)
            
            switch failingResult {
            case .success(let movie):
                XCTAssertEqual(movie.originalTitle, "Mad Max: Fury Road")
            case .failure:
                XCTFail("The request should not fail")
            }
        } catch {
            XCTFail("The request should not fail")
        }
    }
    
    func testMainViewControllerFetchData() throws {
        let viewController = MainViewController(service: MoviesServiceMock())
        
        let expectation = expectation(description: "Fetch data from service")
        
        viewController.loadTableView {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
        
        XCTAssertEqual(viewController.movies.count, 1)
        XCTAssertEqual(viewController.movies.first?.title, "This is a test.")
    }
}

final class MoviesServiceMock: Mockable, MoviesServiceable {
    func getTopRated() async throws -> Result<TopRated, RequestError> {
        return .success(loadJSON(filename: "top_rated_response", type: TopRated.self))
    }

    func getMovieDetail(id: Int) async throws -> Result<Movie, RequestError> {
        return .success(loadJSON(filename: "movie_response", type: Movie.self))
    }
}
