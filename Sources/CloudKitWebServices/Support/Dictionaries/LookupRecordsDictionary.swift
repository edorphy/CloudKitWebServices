//
//  LookupRecordDictionary.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/19/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

struct LookupRecordDictionary: Encodable {
    
    /// The unique name used to identify the record within a zone.
    let recordName: String
    
    // NOTE: This dictionary also supports a `desiredKeys` array, however, this is not something in standard CloudKit so it will not be implemented here. Use the Fetch operation's desired keys property instead.
    
    init(recordName: String) {
        self.recordName = recordName
    }
}
