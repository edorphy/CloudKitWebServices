//
//  ServerErrorCode.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 12/26/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

// https://developer.apple.com/library/archive/documentation/DataManagement/Conceptual/CloudKitWebServicesReference/ErrorCodes.html

enum ServerErrorCode: String, Error, Codable {
    /// You don't have permission to access the endpoint, record, zone, or database.
    case accessDenied = "ACCESS_DENIED"
    
    /// An atomic batch operation failed.
    case atomicError = "ATOMIC_ERROR"
    
    /// Authentication was rejected.
    case authenticationFailed = "AUTHENTICATION_FAILED"
    
    /// The request requires authentication but none was provided.
    case authenticationRequired = "AUTHENTICATION_REQUIRED"
    
    /// The request was not valid.
    case badRequest = "BAD_REQUEST"
    
    /// The `recordChangeTag` value expired. (Retry the request with the latest tag.)
    case conflict = "CONFLICT"
    
    /// The resource that you attempted to create already exists.
    case exists = "EXISTS"
    
    /// An internal error occurred.
    case internalError = "INTERNAL_ERROR"
    
    /// The reousrce was not found.
    case notFound = "NOT_FOUND"
    
    /// If accessing the public database, you exceeded the app's quota. If accessing the private database, you exceeded the user's iCloud quota.
    case quotaExceeded = "QUOTA_EXCEEDED"
    
    /// The request was throttled. Try the request again later.
    case throttled = "THROTTLED"
    
    /// An internal error occurred. Try the request again.
    case tryAgainLater = "TRY_AGAIN_LATER"
    
    /// The request violates a validating reference constraint.
    case validatingReferenceError = "VALIDATING_REFERENCE_ERROR"
    
    /// The zone specified in the request was not found.
    case zoneNotFound = "ZONE_NOT_FOUND"
}

extension ServerErrorCode {
    var statusCode: Int {
        switch self {
        case .accessDenied:
            return 403
            
        case .atomicError:
            return 400
            
        case .authenticationFailed:
            return 401
            
        case .authenticationRequired:
            return 421
            
        case .badRequest:
            return 400
            
        case .conflict:
            return 409
            
        case .exists:
            return 409
            
        case .internalError:
            return 500
            
        case .notFound:
            return 404
            
        case .quotaExceeded:
            return 413
            
        case .throttled:
            return 429
            
        case .tryAgainLater:
            return 503
            
        case .validatingReferenceError:
            return 412
            
        case .zoneNotFound:
            return 404
        }
    }
}
