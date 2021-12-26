//
//  RecordFetchErrorDictionary.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

struct RecordFetchErrorDictionary: Error, Decodable {
    /// The name of the record that the operation failed on.
    let recordName: String?
    
    /// A string indicating the reason for the error.
    let reason: String
    
    /// A string containing the code for the error that occurred.
    let serverErrorCode: ServerErrorCode
    
    /// The suggested time to wait before trying this operation again. If this key is not set, the operation can't be retried.
    let retryAfter: UInt?
    
    /// A unique identifier for this error.
    let uuid: UUID?
    
    /// A redirect URL for the user to securely sign in using their Apple ID. This key is present when `serverErrorCode` is `AUTHENTICATION_REQUIRED`.
    let redirectURL: URL?
}

// TODO: #3 - Add conformance for LocalizableError and CustomNSError
