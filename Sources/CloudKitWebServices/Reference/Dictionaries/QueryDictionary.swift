//
//  QueryDictionary.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

struct QueryDictionary: Encodable {
    
    /// The name of the record type.
    let recordType: String
    
    /// An Array of filter dictionaries (described in Filter Dictionary) used to determine whether a record matches the query.
    let filterBy: [FilterDictionary]?
    
    /// An Array of sort descriptor dictionaries (described in Sort Descriptor Dictionary) that specify how to order the fetched records.
    let sortBy: [SortDescriptorDictionary]?
}

extension QueryDictionary {
    init(query: CKWSQuery) {
        self.recordType = query.recordType
        
        self.filterBy = query.filters?.compactMap({ queryFilter in
            FilterDictionary(queryFilter: queryFilter)
        })
        
        self.sortBy = query.sortDescriptors?.compactMap({ sortDescriptor in
            SortDescriptorDictionary(sortDescriptor: sortDescriptor)
        })
    }
}
