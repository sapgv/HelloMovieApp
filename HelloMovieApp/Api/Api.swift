//
//  Api.swift
//  HelloMovieApp
//
//  Created by Grigory Sapogov on 05.09.2024.
//

import Foundation

final class Api {
    
    static let key = "ВСТАВЬТЕ СЮДА ВАШ API КЛЮЧ"
    
    static let keyHeader = "X-API-KEY"
    
    static let server = "https://kinopoiskapiunofficial.tech/api/v2.2"
    
    func fetchPremiere(completion: @escaping (Swift.Result<[[String: Any]], Error>) -> Void) {
        
        self.requestJson("\(Self.server)/films/premieres?year=2024&month=JANUARY") { result in
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(data):
                
                DispatchQueue.global().async {
                    
                    guard let array = data["items"] as? [[String: Any]] else {
                        DispatchQueue.main.async {
                            completion(.failure(AppErrors.wrongResponse))
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        completion(.success(array))
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func fetchMovieDetail(movieId: Int, completion: @escaping (Swift.Result<[String: Any], Error>) -> Void) {
        
        self.requestJson("\(Self.server)/films/\(movieId)", completion: completion)
        
    }
    
    func fetchImage(posterUrl: String, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        
        self.requestData(posterUrl, completion: completion)
        
    }
    
}

extension Api {
    
    private func requestJson(_ request: String, completion: @escaping (Swift.Result<[String: Any], Error>) -> Void) {
        
        self.requestData(request) { result in
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(data):
                
                DispatchQueue.global().async {
                
                    guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        DispatchQueue.main.async {
                            completion(.failure(AppErrors.wrongResponse))
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        completion(.success(json))
                    }
                    
                }
                
            }
            
        }
        
    }
    
    private func requestData(_ request: String, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        
        DispatchQueue.global().async {
            
            guard let url = URL(string: request) else {
                DispatchQueue.main.async {
                    completion(.failure(AppErrors.wrongURL))
                }
                return
            }
            
            var request = URLRequest(url: url)
            request.addValue(Self.key, forHTTPHeaderField: Self.keyHeader)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    DispatchQueue.main.async {
                        completion(.failure(AppErrors.wrongResponse))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(AppErrors.wrongResponse))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completion(.success(data))
                }
                
            }
            
            task.resume()
            
        }
        
    }
    
}

