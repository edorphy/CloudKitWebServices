//
//  CKQueryOperation-Cursor.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 12/26/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public extension CKQueryOperation {
    struct Cursor {
        let query: CKQuery
        let continuationMarker: String
        
        init?(query: CKQuery, continuationMarker: String?) {
            guard let continuationMarker = continuationMarker else {
                return nil
            }
            
            self.query = query
            self.continuationMarker = continuationMarker
        }
    }
}
