//
//  Record.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public class Record {
    
    public typealias RecordType = String
    
    public typealias FieldKey = String
    
    public let recordID: Record.ID
    public let recordType: RecordType
    
    public let creationDate: Date?
    public let creatorUserRecordID: Record.ID?
    
    public let modificationDate: Date?
    public let lastModifiedUserRecordID: Record.ID?
    
    public let recordChangeTag: String?
    
    public var fields: [String: RecordValueProtocol]
    
    // TODO: Add support for parent, share, allTokens, etc.
    
    public init(recordType: RecordType, recordID: Record.ID) {
        self.recordType = recordType
        self.recordID = recordID
        
        self.creationDate = nil
        self.creatorUserRecordID = nil
        
        self.modificationDate = nil
        self.lastModifiedUserRecordID = nil
        
        self.recordChangeTag = nil
        
        self.fields = [:]
    }
    
    init(recordDictionary: RecordDictionary) {
        self.recordID = Record.ID(recordName: recordDictionary.recordName)
        self.recordType = recordDictionary.recordType
        self.recordChangeTag = recordDictionary.recordChangeTag
        
        if let created = recordDictionary.created {
            // Dates are saved as milliseconds from 1970 so divide by 1000 is required to convert to seconds
            self.creationDate = Date(timeIntervalSince1970: created.timestamp / 1000)
            self.creatorUserRecordID = Record.ID(recordName: created.userRecordName)
        } else {
            self.creationDate = nil
            self.creatorUserRecordID = nil
        }
        
        if let modified = recordDictionary.modified {
            // Dates are saved as milliseconds from 1970 so divide by 1000 is required to convert to seconds
            self.modificationDate = Date(timeIntervalSince1970: modified.timestamp / 1000)
            self.lastModifiedUserRecordID = Record.ID(recordName: modified.userRecordName)
        } else {
            self.modificationDate = nil
            self.lastModifiedUserRecordID = nil
        }
        
        self.fields = Dictionary(uniqueKeysWithValues: recordDictionary.fields.map { key, value in
            (key, value.value)
        })
    }
    
    public subscript(key: String) -> RecordValueProtocol? {
        fields[key]
    }
}
