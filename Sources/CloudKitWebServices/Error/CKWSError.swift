//
//  CKWSError.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 12/26/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public struct CKWSError: Error {
    public let code: Code
    public let userInfo: [String: Any]
    
    public init(code: Code, userInfo: [String: Any] = [:]) {
        self.code = code
        self.userInfo = userInfo
    }
}

public extension CKWSError {
    
    // https://developer.apple.com/documentation/cloudkit/ckerror/code
    
    enum Code: Int {
        case accountTemporarilyUnavailable
        case alreadyShared
        case assetFieldModified
        case assetFileNotFound
        case assetNotAvailable
        case badContainer
        case badDatabase
        case batchRequestFailed
        case changeTokenExpired
        case constraintViolation
        case incompatibleVersion
        case internalError
        case invalidArguments
        case limitExceeded
        case managedAccountRestricted
        case missingEntitlement
        case networkFailure
        case networkUnavailable
        case notAuthenticated
        case operationCancelled
        case partialFailure
        case participantMayNeedVerification
        case permissionFailure
        case quotaExceeded
        case referenceViolation
        case requestRateLimited
        case serverRecordChanged
        case serverRejectedRequest
        case serverResponseLost
        case serviceUnavailable
        case tooManyParticipants
        case unknownItem
        case userDeletedZone
        case zoneBusy
        case zoneNotFound
    }
}

extension CKWSError: LocalizedError {
    // TODO: Implement this
}

extension CKWSError: CustomNSError {
    
    public var errorCode: Int {
        code.rawValue
    }
    
    public var errorUserInfo: [String : Any] {
        userInfo
    }
    
    public static var errorDomain: String {
        "CKWSErrorDomain"
    }
}

internal extension CKWSError {
    init(errorDictionary: RecordFetchErrorDictionary) {
        switch errorDictionary.serverErrorCode {
        case .notFound:
            // TODO: Identify CloudKit behavior for contents of error, check if any userInfo
            self.init(code: .unknownItem)
            
        default:
            // TODO: Find the correct mapping for other errors
            fatalError("Unexpected error received in record fetch operation, file a bug describing what you did")
        }
    }
}
