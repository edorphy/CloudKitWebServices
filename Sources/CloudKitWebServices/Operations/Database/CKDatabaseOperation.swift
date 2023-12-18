//
//  CKDatabaseOperation.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/12/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public class CKDatabaseOperation: CKOperation {
    var database: CKDatabase?
}

internal extension CKDatabaseOperation {
    func getRecordsURL(database: CKDatabase) -> URL {
        let url = database.getURL()
        return url.appendingPathComponent("records")
    }
}
