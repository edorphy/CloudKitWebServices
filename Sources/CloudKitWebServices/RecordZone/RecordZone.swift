//
//  RecordZone.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/16/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

/// A database partition that contains related records.
public struct RecordZone {
    let zoneID: RecordZone.ID
    let capabilites: RecordZone.Capabilites

    // TODO: init(zoneName: String), uses default user as owner name... which read only cloudkit doesn't have
    
    init(zoneID: RecordZone.ID) {
        self.zoneID = zoneID
        self.capabilites = RecordZone.Capabilites()
    }
    
    /// Returns the default record zone.
    /// - Returns: Returns the default record zone.
    static func `default`() -> RecordZone {
        RecordZone(zoneID: .default)
    }
}
