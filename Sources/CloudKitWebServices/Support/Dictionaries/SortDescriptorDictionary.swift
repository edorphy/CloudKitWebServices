//
//  SortDescriptorDictionary.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

struct SortDescriptorDictionary: Encodable {
    let fieldName: String
    let ascending: Bool
    let relativeLocation: LocationDictionary?
}

extension SortDescriptorDictionary {
    init?(sortDescriptor: NSSortDescriptor) {
        guard let fieldName = sortDescriptor.key else {
            return nil
        }
        
        self.fieldName = fieldName
        self.ascending = sortDescriptor.ascending
        
        // TODO: Add support for location based sort descriptor
        self.relativeLocation = nil
    }
}
