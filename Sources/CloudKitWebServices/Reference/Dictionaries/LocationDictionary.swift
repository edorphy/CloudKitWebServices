//
//  LocationDictionary.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import CoreLocation

struct LocationDictionary: Codable {
    
    /// The latitude of the coordinate point.
    let latitude: Double
    
    /// The longitude of the coordinate point.
    let longitude: Double
    
    /// The radius of uncertainty for the location, measured in meters.
    let horizontalAccuracy: Double?
    
    /// The accuracy of the altitude value in meters.
    let verticalAccuracy: Double?
    
    /// The altitude measured in meters.
    let altitude: Double?
    
    /// The instantaneous speed of the device in meters per second.
    let speed: Double?
    
    // TODO: This is in CLLocation but not LocationDictionary?
    let speedAccuracy: Double?
    
    /// The direction in which the device is traveling.
    let course: Double?
    
    // TODO: This is in CLLocation but not LocationDictionary?
    let courseAccuracy: Double?
    
    /// The time at which this location was determined.
    let timestamp: Date?
}

extension CLLocation {
    convenience init(locationDictionary: LocationDictionary) {
        
        let verticalAccuracy = locationDictionary.verticalAccuracy ?? -1
        let horizontalAccuracy = locationDictionary.horizontalAccuracy ?? -1
        let courseAccuracy = -1
        let speedAccuracy = -1
        
        let altitude: Double = {
            if verticalAccuracy < 0 {
                return 0
            } else {
                return locationDictionary.altitude ?? 0
            }
        }()
        
        let course: Double = {
            if courseAccuracy < 0 {
                return 0
            } else {
                return locationDictionary.course ?? 0
            }
        }()
        
        let speed: Double = {
            if speedAccuracy < 0 {
                return 0
            } else {
                return locationDictionary.speed ?? 0
            }
        }()
        
        let coordinate = CLLocationCoordinate2D(latitude: locationDictionary.latitude, longitude: locationDictionary.longitude)
        
        if #available(iOS 13.4, macOS 10.15.4, tvOS 13.4, watchOS 6.2, *) {
            self.init(
                coordinate: coordinate,
                altitude: altitude,
                horizontalAccuracy: horizontalAccuracy,
                verticalAccuracy: verticalAccuracy,
                course: course,
                courseAccuracy: -1,
                speed: speed,
                speedAccuracy: -1,
                timestamp: locationDictionary.timestamp ?? Date()
            )
        } else {
            self.init(
                coordinate: coordinate,
                altitude: altitude,
                horizontalAccuracy: horizontalAccuracy,
                verticalAccuracy: verticalAccuracy,
                course: course,
                speed: speed,
                timestamp: locationDictionary.timestamp ?? Date()
            )
        }
    }
}
