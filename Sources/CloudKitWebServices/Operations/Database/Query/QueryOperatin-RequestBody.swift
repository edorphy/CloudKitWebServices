//
//  QueryOperation.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

extension QueryOperation {
    struct RequestBody: Encodable {
        // TODO: ZoneID
        
        /// The maximum number of records to fetch.
        let resultsLimit: Int
        
        /// The query to apply.
        let query: QueryDictionary
        
        /// The location of the last batch of results. Use this key when the results of a previous fetch exceeds the maximum.
        let continuationMarker: String?
        
        /// An array of strings containing record field names that limits the amount of data returned in this operation. Only the fields specified in the array are returned. The default is `null`, which fetches all record fields.
        let desiredKeys: [String]?
        
        /// A Boolean value determining whether all zones should be searched. This key is ignored if zoneID is non-null. To search all zones, set to true. To search the default zone only, set to false.
        let zoneWide: Bool? = false
        
        /// A Boolean value indicating whether number fields should be represented by strings. The default value is false.
        let numbersAsStrings: Bool? = false
    }
}
