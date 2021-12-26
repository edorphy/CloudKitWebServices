//
//  Record-Reference.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/16/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public extension CKWSRecord {
    struct Reference: Equatable, Hashable {
        public let recordID: CKWSRecord.ID
        public let action: ReferenceAction
        
        public init(recordID: CKWSRecord.ID, action: ReferenceAction) {
            self.recordID = recordID
            self.action = action
        }
        
        public init(record: CKWSRecord, action: ReferenceAction) {
            self.recordID = record.recordID
            self.action = action
        }
        
        internal init(reference: ReferenceDictionary) {
            self.recordID = CKWSRecord.ID(recordName: reference.recordName)
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
