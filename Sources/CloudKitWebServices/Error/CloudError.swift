//
//  CloudError.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

enum CloudError: String, Error, Codable {
    case accessDenied = "ACCESS_DENIED"
    case atomicError = "ATOMIC_ERROR"
    case authenticationFailed = "AUTHENTICATION_FAILED"
    case authenticationRequired = "AUTHENTICATION_REQUIRED"
    case badRequest = "BAD_REQUEST"
    case conflict = "CONFLICT"
    case exists = "EXISTS"
    case internalError = "INTERNAL_ERROR"
    case notFound = "NOT_FOUND"
    case quotaExceeded = "QUOTA_EXCEEDED"
    case throttled = "THROTTLED"
    case tryAgainLater = "TRY_AGAIN_LATER"
    case validatingReferenceError = "VALIDATING_REFERENCE_ERROR"
    case zoneNotFound = "ZONE_NOT_FOUND"
}

extension CloudError: CustomStringConvertible {
    var description: String {
        switch self {
        case .accessDenied:
            return "You don't have permission to access the endpoint, record, zone, or database."
        case .atomicError:
            return "An atomic batch operation failed."
        case .authenticationFailed:
            return "Authentication was rejected."
        case .authenticationRequired:
            return "The request requires authentication but none was provided."
        case .badRequest:
            return "The request was not valid."
        case .conflict:
            return "The `recordChangeTag` value expired. (Retry the request with the latest tag.)"
        case .exists:
            return "The resource that you attempted to create already exists."
        case .internalError:
            return "An internal error occurred."
        case .notFound:
            return "The resource was not found."
        case .quotaExceeded:
            return "If accessing the public database, you exceeded the app's quota. If accessing the private database, you exceeded the user's iCloud quota."
        case .throttled:
            return "The request was throttled. Try the request again later"
        case .tryAgainLater:
            return "An internal error occurred. Try the request again later."
        case .validatingReferenceError:
            return "The request violates a validating reference constraint."
        case .zoneNotFound:
            return "The zone specified in the request was not found."
        }
    }
}

// TODO: #3 - Add conformance for LocalizableError and CustomNSError

extension CloudError {
    var statusCode: UInt {
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
