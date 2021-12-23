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
    
    public let recordID: Record.ID
    public let recordType: RecordType
    public let recordChangeTag: String?
    public let creationDate: Date?
    public let modificationDate: Date?
//    let lastModifiedUserRecordID: String?
    
    public var fields: [String: RecordValueProtocol]
    
    public init(recordType: RecordType, recordID: Record.ID) {
        self.recordType = recordType
        self.recordID = recordID
        self.recordChangeTag = nil
        
        self.creationDate = nil
        self.modificationDate = nil
//        self.lastModifiedUserRecordID = nil
        
        self.fields = [:]
    }
    
    init(recordDictionary: RecordDictionary) {
        self.recordID = Record.ID(recordName: recordDictionary.recordName)
        self.recordType = recordDictionary.recordType
        self.recordChangeTag = recordDictionary.recordChangeTag
        
        self.creationDate = {
            guard let interval = recordDictionary.created?.timestamp else {
                return nil
            }
            
            return Date(timeIntervalSinceReferenceDate: interval)
        }()
        
        self.modificationDate = {
            guard let interval = recordDictionary.modified?.timestamp else {
                return nil
            }
            
            return Date(timeIntervalSinceReferenceDate: interval)
        }()
        
        self.fields = Dictionary(uniqueKeysWithValues: recordDictionary.fields.map { key, value in
            (key, value.value)
        })
    }
    
    public subscript(key: String) -> RecordValueProtocol? {
        fields[key]
    }
}
