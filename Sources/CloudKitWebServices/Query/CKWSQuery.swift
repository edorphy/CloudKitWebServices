//
//  CKWSQuery.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public struct CKWSQuery {
    public let recordType: String
    
    public let filters: [CKWSQuery.Filter]?
    
    public var sortDescriptors: [NSSortDescriptor]?
    
    public init(recordType: String, filters: [CKWSQuery.Filter]? = nil) {
        self.recordType = recordType
        self.filters = filters
    }
}
