//
//  CKQuery-Filter.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/16/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public extension CKQuery {
    struct Filter {
        let name: String
        let comparator: Comparator
        let value: CKRecordValueProtocol
        let distance: Double?
    }
}

public extension CKQuery.Filter {
    init(name: String, comparator: CKQuery.Filter.Comparator, value: CKRecordValueProtocol) {
        self.name = name
        self.comparator = comparator
        self.value = value
        self.distance = nil
    }
    
    internal func getRecordFieldValue() -> RecordFieldDictionary {
        switch value {
        case let stringValue as String:
            return RecordFieldDictionary(value: stringValue, type: .string)
            
        case let referenceValue as ReferenceDictionary:
            return RecordFieldDictionary(value: referenceValue, type: .reference)
            
        case let recordReferenceValue as CKRecord.Reference:
            return RecordFieldDictionary(value: recordReferenceValue, type: .reference)
            
        default:
            fatalError("if you encounter this, open up a PR for the unhandled type")
        }
    }
}

public extension CKQuery.Filter {
    enum Comparator: String, Codable {
        case equals = "EQUALS"
        case lessThan = "LESS_THAN"
        case beginsWith = "BEGINS_WITH"
        case listContains = "LIST_CONTAINS"
    }
}
