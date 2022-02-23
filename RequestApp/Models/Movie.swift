//
//  Movie.swift
//  RequestApp
//
//  Created by Victor Catão on 30/01/22.
//

import Foundation

struct Movie: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]?
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case adult
        case overview
        case popularity
        case id
        case title
        case video
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
