//
//  ZoneIDDictionary.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/16/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

/// The zone ID identifies an aerea for organizing related records in a database.
struct ZoneIDDictionary: Codable {
    /// The name that identifies the record zone. The default value is `_defaultZone`, which indicates the default zone of the current database.
    let zoneName: String
    
    /// String representing the zone owner’s user record name. Use this key to identify a zone owned by another user. The default value is the current user’s record name.
    let ownerRecordName: String
    
    static var defaultZone: ZoneIDDictionary {
        ZoneIDDictionary(zoneName: "_defaultZone", ownerRecordName: "_defaultOwner")
    }
}
