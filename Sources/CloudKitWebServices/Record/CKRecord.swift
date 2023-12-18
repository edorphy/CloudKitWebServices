//
//  CKRecord.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public class CKRecord {
    
    public typealias RecordType = String
    
    public typealias FieldKey = String
    
    public let recordID: CKRecord.ID
    public let recordType: RecordType
    
    public let creationDate: Date?
    public let creatorUserRecordID: CKRecord.ID?
    
    public let modificationDate: Date?
    public let lastModifiedUserRecordID: CKRecord.ID?
    
    public let recordChangeTag: String?
    
    public var fields: [String: CKRecordValueProtocol]
    
    // TODO: Add support for parent, share, allTokens, etc.
    
    public init(recordType: RecordType, recordID: CKRecord.ID) {
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
        self.recordID = CKRecord.ID(recordName: recordDictionary.recordName)
        self.recordType = recordDictionary.recordType
        self.recordChangeTag = recordDictionary.recordChangeTag
        
        if let created = recordDictionary.created {
            // Dates are saved as milliseconds from 1970 so divide by 1000 is required to convert to seconds
            self.creationDate = Date(timeIntervalSince1970: created.timestamp / 1000)
            self.creatorUserRecordID = CKRecord.ID(recordName: created.userRecordName)
        } else {
            self.creationDate = nil
            self.creatorUserRecordID = nil
        }
        
        if let modified = recordDictionary.modified {
            // Dates are saved as milliseconds from 1970 so divide by 1000 is required to convert to seconds
            self.modificationDate = Date(timeIntervalSince1970: modified.timestamp / 1000)
            self.lastModifiedUserRecordID = CKRecord.ID(recordName: modified.userRecordName)
        } else {
            self.modificationDate = nil
            self.lastModifiedUserRecordID = nil
        }
        
        self.fields = Dictionary(uniqueKeysWithValues: recordDictionary.fields.map { key, value in
            (key, value.value)
        })
    }
    
    public subscript(key: String) -> CKRecordValueProtocol? {
        fields[key]
    }
}
