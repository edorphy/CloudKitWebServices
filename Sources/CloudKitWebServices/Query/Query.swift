//
//  Query.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public struct Query {
    public let recordType: String
    
    public let filters: [Query.Filter]?
    
    public var sortDescriptors: [NSSortDescriptor]?
    
    public init(recordType: String, filters: [Query.Filter]? = nil) {
        self.recordType = recordType
        self.filters = filters
    }
}
