//
//  CKRecord-ID.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/16/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public extension CKRecord {
    
    /// An object that uniquely identifies a record in a database.
    struct ID: Equatable, Hashable {
        public let recordName: String
        public let zoneID: CKRecordZone.ID
        
        public init(recordName: String) {
            self.recordName = recordName
            self.zoneID = .default
        }
        
        /// Creates a new record ID with the specified name and zone information.
        /// - Parameters:
        ///   - recordName: The name that identifies the record. The string must contain only ASCII characters, must not exceed 255 characters, and must not start with an underscore.
        ///   - zoneID: The ID of the record zone where you want to store the record.
        ///
        /// Use this method when you create or search for records in a zone other than the default zone. The value in the zoneID parameter must represent a zone that already exists in the database. If the record zone doesn’t exist, save the corresponding CKRecordZone object to the database before attempting to save any CKRecord objects in that zone.
        public init(recordName: String, zoneID: CKRecordZone.ID) {
            self.recordName = recordName
            self.zoneID = zoneID
        }
    }
}
