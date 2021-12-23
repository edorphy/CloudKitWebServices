//
//  LocationDictionary-CoreLocation.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/16/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import CoreLocation

extension LocationDictionary {
    init(from location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.horizontalAccuracy = location.horizontalAccuracy
        self.verticalAccuracy = location.verticalAccuracy
        self.altitude = location.altitude
        self.speed = location.speed
        self.course = location.course
        self.timestamp = location.timestamp
        
        if #available(iOS 10.0, macOS 10.15, tvOS 10.0, watchOS 3.0, *) {
            self.speedAccuracy = location.speedAccuracy
        } else {
            self.speedAccuracy = -1
        }
        
        if #available(iOS 13.4, macOS 10.15.4, tvOS 13.4, watchOS 6.2, *) {
            self.courseAccuracy = location.courseAccuracy
        } else {
            self.courseAccuracy = -1
        }
    }
}
