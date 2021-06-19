//
//  Error.swift
//  RocketApp
//
//  Created by iOS Developer on 19/06/21.
//

import Foundation

enum AppError: Error {
    case unprocessableRequest
    case unprocessableResponse
    case unknown
}

extension AppError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unprocessableRequest:
            return "Failed to process request"
        case .unprocessableResponse:
            return "Failed to process request"
        case .unknown:
            return "Something went wrong"
        }
    }
}
