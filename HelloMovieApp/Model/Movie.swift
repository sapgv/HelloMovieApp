//
//  Movie.swift
//  HelloMovieApp
//
//  Created by Grigory Sapogov on 05.09.2024.
//

import Foundation

class Movie {
    
    let id: Int
    
    let name: String
    
    let year: Int
    
    let posterUrl: String
    
    let duration: Int?
    
    init(
        id: Int,
        name: String,
        year: Int,
        posterUrl: String,
        duration: Int
    ) {
        self.id = id
        self.name = name
        self.year = year
        self.posterUrl = posterUrl
        self.duration = duration
    }
    
    init(data: [String: Any]) throws {
        guard let id = data["kinopoiskId"] as? Int else { throw AppErrors.parseError(object: "Movie")}
        guard let name = data["nameRu"] as? String else { throw AppErrors.parseError(object: "Movie")}
        guard let year = data["year"] as? Int else { throw AppErrors.parseError(object: "Movie")}
        guard let posterUrl = data["posterUrl"] as? String else { throw AppErrors.parseError(object: "Movie")}
        self.id = id
        self.name = name
        self.year = year
        self.posterUrl = posterUrl
        self.duration = data["duration"] as? Int
    }
    
}

extension Movie {
    
    var durationTitle: String {
        
        guard let duration = self.duration else { return "" }
        
        let h = duration / 60
        
        let m = duration % 60
        
        let hourTitle = h > 0 ? "\(h) ч" : ""
        
        let minTitle = "\(m) мин"
        
        let title = "\(hourTitle) \(minTitle)".trimmingCharacters(in: .whitespaces)
        
        return title
        
    }
    
}
