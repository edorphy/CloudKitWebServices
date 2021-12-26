//
//  Query-Filter.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/16/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public extension CKWSQuery {
    struct Filter {
        let name: String
        let comparator: Comparator
        let value: CKWSRecordValueProtocol
        let distance: Double?
    }
}

public extension CKWSQuery.Filter {
    init(name: String, comparator: CKWSQuery.Filter.Comparator, value: CKWSRecordValueProtocol) {
        self.name = name
        self.comparator = comparator
        self.value = value
        self.distance = nil
    }
    
    internal func getRecordFieldValue() -> RecordFieldDictionary {
        switch value {
        case let stringValue as String:
            return RecordFieldDictionary(value: stringValue, type: "STRING")
            
        case let referenceValue as ReferenceDictionary:
            return RecordFieldDictionary(value: referenceValue, type: "REFERENCE")
            
        case let recordReferenceValue as CKWSRecord.Reference:
            return RecordFieldDictionary(value: recordReferenceValue, type: "REFERENCE")
            
        default:
            assertionFailure("Need to implement this")
            fatalError("if you encounter this, open up a PR for the unhandled type")
        }
    }
}

public extension CKWSQuery.Filter {
    enum Comparator: String, Codable {
        case equals = "EQUALS"
        case lessThan = "LESS_THAN"
        case beginsWith = "BEGINS_WITH"
    }
}
