//
//  CKRecordZone.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/16/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public extension CKRecordZone {
    struct Capabilites: OptionSet {
        public let rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        // TODO: Capabilities are not really supported in public database's default zone. Maybe nuke this class and property.
    }
}
