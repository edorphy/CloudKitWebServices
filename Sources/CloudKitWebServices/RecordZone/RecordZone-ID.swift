//
//  RecordZone-ID.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/16/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public extension RecordZone {
    struct ID: Hashable {
        let zoneName: String
        let ownerName: String
        
        init(zoneName: String, ownerName: String) {
            self.zoneName = zoneName
            self.ownerName = ownerName
        }
        
        static let `default`: RecordZone.ID = RecordZone.ID(zoneName: defaultZoneName, ownerName: "")
        static let defaultZoneName: String = "_defaultZone"
    }
}
