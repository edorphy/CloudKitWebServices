//
//  CKWSDatabaseOperation.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/12/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public class CKWSDatabaseOperation: CKWSOperation {
    var database: CKWSDatabase?
}

internal extension CKWSDatabaseOperation {
    func getRecordsURL(database: CKWSDatabase) -> URL {
        let url = database.getURL()
        return url.appendingPathComponent("records")
    }
}
