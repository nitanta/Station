//
//  AppError.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 04/07/2022.
//

import Foundation

enum APIServerError: Int, LocalizedError {
    case badRequest = 400
    case unAuthorized = 401
    case serverError = 500
    case notFound = 404
    
    var errorDescription: String? {
        return Constants.apiErrorTitle
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .serverError:
            return Constants.serverError
        case .notFound:
            return Constants.notFound
        default:
            return Constants.somethingWrong
        }
    }
    
    struct Constants {
        static let apiErrorTitle = "Server error"
        static let serverError = "Server error."
        static let notFound = "The data you are looking is not out there."
        static let somethingWrong = "Something went wrong."
    }
}

enum APPError: LocalizedError {
    case invalidURL
    case dataNil
    case decodingError
    case noInternet
    case custom(String)
    
    var recoverySuggestion: String? {
        switch self {
        case .dataNil:
            return Constants.emptyData
        case .decodingError:
            return Constants.invalidFormat
        case .noInternet:
            return Constants.notConnected
        case .custom(let error):
            return error
        case .invalidURL:
            return Constants.somethingWrong
        }
    }
    
    var errorDescription: String? {
        return Constants.error
    }
    
    struct Constants {
        static let error = "Error"
        static let emptyData = "Empty data."
        static let invalidFormat = "Data has invalid format."
        static let notConnected = "You are not connected to the internet."
        static let somethingWrong = "Something went wrong."
    }
}
