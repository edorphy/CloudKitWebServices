//
//  CKQuery-Filter-LocationDistance.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/16/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import CoreLocation
import Foundation

public extension CKQuery.Filter {
    init(name: String, distance: Double, to location: CLLocation) {
        self.name = name
        self.comparator = .lessThan
        self.value = LocationDictionary(from: location)
        self.distance = distance
    }
}
