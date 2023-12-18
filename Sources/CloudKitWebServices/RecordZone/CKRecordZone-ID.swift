//
//  CKRecordZone-ID.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/16/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public extension CKRecordZone {
    struct ID: Hashable {
        let zoneName: String
        let ownerName: String
        
        init(zoneName: String, ownerName: String) {
            self.zoneName = zoneName
            self.ownerName = ownerName
        }
        
        static let `default`: CKRecordZone.ID = CKRecordZone.ID(zoneName: defaultZoneName, ownerName: "")
        static let defaultZoneName: String = "_defaultZone"
    }
}
