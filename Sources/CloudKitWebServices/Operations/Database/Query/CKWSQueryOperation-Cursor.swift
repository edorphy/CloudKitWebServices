//
//  CKWSQueryOperation-Cursor.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 12/26/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public extension CKWSQueryOperation {
    struct Cursor {
        let query: CKWSQuery
        let continuationMarker: String
        
        init?(query: CKWSQuery, continuationMarker: String?) {
            guard let continuationMarker = continuationMarker else {
                return nil
            }
            
            self.query = query
            self.continuationMarker = continuationMarker
        }
    }
}
