//
//  AppErrors.swift
//  HelloMovieApp
//
//  Created by Grigory Sapogov on 05.09.2024.
//

import Foundation

enum AppErrors: Error {
    
    case wrongURL
    case wrongResponse
    case parseError(object: String)
    case wrongImageData
    
}

