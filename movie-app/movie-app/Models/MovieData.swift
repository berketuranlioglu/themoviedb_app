//
//  MovieData.swift
//  movie-app
//
//  Created by S69512 on 9/21/22.
//

import Foundation

struct MovieData: Codable {
    let page: Int
    let results: [Movie]
}

struct Movie: Codable {
    let title: String
    let poster_path: String
    let vote_average: Double
    let release_date: String
    let overview: String
}

struct MovieModel: Hashable {
    let name: String
    let image: String
    let rating: Double
    let date: String
    let overview: String
}
