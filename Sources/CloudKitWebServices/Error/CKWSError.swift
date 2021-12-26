//
//  CKWSError.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 12/26/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public struct CKWSError: Error {
    let code: Code
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
    // TODO: Implement this
}
