//
//  QueryOperation.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

extension QueryOperation {
    struct ResponseBody: Decodable {
        let records: [RecordDictionary]
        let continuationMarker: String?
    }
}
