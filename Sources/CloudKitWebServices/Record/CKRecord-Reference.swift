//
//  CKRecord-Reference.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/16/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public extension CKRecord {
    struct Reference: Equatable, Hashable {
        public let recordID: CKRecord.ID
        public let action: ReferenceAction
        
        public init(recordID: CKRecord.ID, action: ReferenceAction) {
            self.recordID = recordID
            self.action = action
        }
        
        public init(record: CKRecord, action: ReferenceAction) {
            self.recordID = record.recordID
            self.action = action
        }
        
        internal init(reference: ReferenceDictionary) {
            self.recordID = CKRecord.ID(recordName: reference.recordName)
            self.action = {
                guard let action = reference.action else { return .none }
                switch action {
                case .deleteSelf:
                    return .deleteSelf
                    
                case .none:
                    return .none
                    
                case .validate:
                    fatalError("How do we map validate action to CKRecord.ReferenceAction?")
                }
            }()
        }
    }
    
    enum ReferenceAction: UInt {
        // swiftlint:disable:next discouraged_none_name
        case none
        case deleteSelf
    }
}
