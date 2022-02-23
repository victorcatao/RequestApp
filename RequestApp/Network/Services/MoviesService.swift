//
//  MoviesService.swift
//  RequestApp
//
//  Created by Victor Catão on 18/02/22.
//

import Foundation

protocol MoviesServiceable {
    func getTopRated() async throws -> Result<TopRated, RequestError>
    func getMovieDetail(id: Int) async throws -> Result<Movie, RequestError>
}

struct MoviesService: HTTPClient, MoviesServiceable {
    func getTopRated() async throws -> Result<TopRated, RequestError> {
        return try await sendRequest(endpoint: MoviesEndpoint.topRated, responseModel: TopRated.self)
    }
    
    func getMovieDetail(id: Int) async throws -> Result<Movie, RequestError> {
        return try await sendRequest(endpoint: MoviesEndpoint.movieDetail(id: id), responseModel: Movie.self)
    }
}
