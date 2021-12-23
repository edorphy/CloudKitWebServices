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
    
    /// An array of strings containing record field names that limits the amount of data returned in this operation. Only the fields specified in the array are returned. The default is `null`, which fetches all record fields.
    let desiredKeys: [String]?
    
    init(recordName: String, desiredKeys: [String]? = nil) {
        self.recordName = recordName
        self.desiredKeys = desiredKeys
    }
}
