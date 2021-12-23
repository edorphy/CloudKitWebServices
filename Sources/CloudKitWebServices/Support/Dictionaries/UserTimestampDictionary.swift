//
//  UserTimestampDictionary.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 12/22/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

// TODO: Identify what this is actually called, it isn't in the spec
struct UserTimestampDictionary: Codable {
    // TODO: This field is returned as epoch ticks, but would be much more user friendly to provide a Date and do custom decoding.
    let timestamp: TimeInterval
    let userRecordName: String
    
    // TODO: Figure out what this is used for
    let deviceID: String
}
