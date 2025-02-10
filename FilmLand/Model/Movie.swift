//
//  Movie.swift
//  FilmLand
//
//  Created by Jorge Azurduy on 2/9/25.
//

// MARK: - Welcome
struct ResultMedia: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults :Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Movie: Codable, Hashable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let overview: String
    let originalTitle: String
    let popularity: Double
    let posterPath: String?
    let title: String
    let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case overview
        case originalTitle = "original_title"
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


