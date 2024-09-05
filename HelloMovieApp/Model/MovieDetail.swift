//
//  MovieDetail.swift
//  HelloMovieApp
//
//  Created by Grigory Sapogov on 05.09.2024.
//

import Foundation

final class MovieDetail: Movie {
    
    let ratingKinopoisk: Double?
    
    let ratingImdb: Double?
    
    let slogan: String?
    
    let description: String?
    
    init(
        id: Int,
        name: String,
        year: Int,
        posterUrl: String,
        duration: Int,
        ratingKinopoisk: Double,
        ratingImdb: Double,
        slogan: String,
        description: String
    ) {
        self.ratingKinopoisk = ratingKinopoisk
        self.ratingImdb = ratingImdb
        self.slogan = slogan
        self.description = description
        super.init(id: id, name: name, year: year, posterUrl: posterUrl, duration: duration)
    }
    
    override init(data: [String: Any]) throws {
        self.ratingKinopoisk = data["ratingKinopoisk"] as? Double
        self.ratingImdb = data["ratingImdb"] as? Double
        self.slogan = data["slogan"] as? String
        self.description = data["description"] as? String
        try super.init(data: data)
    }
    
}
