//
//  Query-Filter.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/16/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public extension Query {
    struct Filter {
        let name: String
        let comparator: Comparator
        let value: RecordValueProtocol
        let distance: Double?
    }
}

public extension Query.Filter {
    init(name: String, comparator: Query.Filter.Comparator, value: RecordValueProtocol) {
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
            
        case let recordReferenceValue as Record.Reference:
            return RecordFieldDictionary(value: recordReferenceValue, type: "REFERENCE")
            
        default:
            assertionFailure("Need to implement this")
            fatalError("if you encounter this, open up a PR for the unhandled type")
        }
    }
}

public extension Query.Filter {
    enum Comparator: String, Codable {
        case equals = "EQUALS"
        case lessThan = "LESS_THAN"
        case beginsWith = "BEGINS_WITH"
    }
}
