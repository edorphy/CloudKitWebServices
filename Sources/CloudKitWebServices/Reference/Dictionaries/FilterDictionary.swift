//
//  FilterDictionary.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

struct FilterDictionary: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case comparator
        case fieldName
        case fieldValue
        case distance
    }
    
    let comparator: CKQuery.Filter.Comparator
    let fieldName: String?
    let fieldValue: RecordFieldDictionary
    let distance: Double?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(comparator, forKey: .comparator)
        try container.encode(fieldValue, forKey: .fieldValue)
        try container.encode(fieldName, forKey: .fieldName)
        try container.encode(distance, forKey: .distance)
    }
}

extension FilterDictionary {
    init(queryFilter: CKQuery.Filter) {
        self.comparator = queryFilter.comparator
        self.fieldName = queryFilter.name
        self.fieldValue = queryFilter.getRecordFieldValue()
        self.distance = nil
    }
}
