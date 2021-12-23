//
//  FetchRecordsRequestBody.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/12/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

extension FetchRecordsOperation {
    struct RequestBody: Encodable {
        
        /// Array of record dictionaries, described in Lookup Record Dictionary, identifying the records to fetch.
        let records: [LookupRecordDictionary]
        
        // TODO: ZoneID
        
        // TODO: DesiredKeys
        
        // TODO: numbersAsStrings
    }
}
