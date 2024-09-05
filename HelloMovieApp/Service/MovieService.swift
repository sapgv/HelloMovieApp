//
//  MovieService.swift
//  HelloMovieApp
//
//  Created by Grigory Sapogov on 05.09.2024.
//

import Foundation
import UIKit

final class MovieService {
    
    private let api: Api
    
    private var images: [String: UIImage] = [:]
    
    init(api: Api = Api()) {
        self.api = api
    }
    
    func fetchPremiere(completion: @escaping (Swift.Result<[Movie], Error>) -> Void) {
        
        self.api.fetchPremiere { [weak self] result in
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(array):
                self?.parseMovies(array: array, completion: completion)
            }
            
        }
        
    }
    
    func fetchMovieDetail(movieId: Int, completion: @escaping (Swift.Result<MovieDetail, Error>) -> Void) {
        
        self.api.fetchMovieDetail(movieId: movieId) { result in
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(data):
                
                DispatchQueue.global().async {
                    
                    do {
                        let movieDetail = try MovieDetail(data: data)
                        DispatchQueue.main.async {
                            completion(.success(movieDetail))
                        }
                    }
                    catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func fetchImage(posterUrl: String, completion: @escaping (Swift.Result<UIImage, Error>) -> Void) {
        
        if let image = self.images[posterUrl] {
            completion(.success(image))
            return
        }
        
        self.api.fetchImage(posterUrl: posterUrl) { [weak self] result in
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(data):
                
                DispatchQueue.global().async {
                    
                    guard let image = UIImage(data: data) else {
                        DispatchQueue.main.async {
                            completion(.failure(AppErrors.wrongImageData))
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self?.images[posterUrl] = image
                        completion(.success(image))
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

extension MovieService {
    
    private func parseMovies(array: [[String: Any]], completion: @escaping (Swift.Result<[Movie], Error>) -> Void) {
        
        DispatchQueue.global().async {
            
            do {
                let movies = try array.map { movieData in
                    let movie = try Movie(data: movieData)
                    return movie
                }
                
                DispatchQueue.main.async {
                    completion(.success(movies))
                }
                
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }
        
    }
    
}
