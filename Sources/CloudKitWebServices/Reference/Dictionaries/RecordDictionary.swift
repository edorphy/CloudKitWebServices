//
//  RecordDictionary.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

struct RecordDictionary: Codable {
    let recordName: String
    let recordType: String
    let recordChangeTag: String
    let fields: [String: RecordFieldDictionary]
    
    let created: UserTimestampDictionary?
    let modified: UserTimestampDictionary?
}
