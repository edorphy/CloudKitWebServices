//
//  CKWSError.swift
//  
//
//  Created by Eric Dorphy on 12/26/21.
//

import Foundation

public struct CKWSError: Error {
    
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
    
}

extension CKWSError: CustomNSError {
    
}
