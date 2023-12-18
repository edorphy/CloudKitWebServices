//
//  ReferenceDictionary.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

struct ReferenceDictionary: Codable {
    let recordName: String
    
    let zoneID: ZoneIDDictionary?
    
    let action: Action?
    
    init(recordName: String, zoneID: ZoneIDDictionary = .defaultZone) {
        self.recordName = recordName
        self.zoneID = zoneID
        self.action = nil
    }
    
    init(recordName: String, action: Action) {
        self.recordName = recordName
        self.zoneID = nil
        self.action = action
    }
    
    init(reference: CKRecord.Reference) {
        self.recordName = reference.recordID.recordName
        self.zoneID = nil
        self.action = nil
        
        // TODO: Implement this properly
        // self.zoneID = reference.recordID.zoneID
        // self.action = reference.action
    }
}

extension ReferenceDictionary {
    enum Action: String, Codable {
        // swiftlint:disable:next discouraged_none_name
        case none = "NONE"
        case deleteSelf = "DELETE_SELF"
        case validate = "VALIDATE"
    }
}
