//
//  PartialFailure.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 12/22/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

struct PartialFailure: Error {
    let failedRecords: [CKWSRecord.ID: RecordFetchErrorDictionary]
    
    init?(failedRecords: [CKWSRecord.ID: RecordFetchErrorDictionary]) {
        guard failedRecords.isEmpty == false else {
            return nil
        }
        
        self.failedRecords = failedRecords
    }
}
