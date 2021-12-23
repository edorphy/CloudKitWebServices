//
//  RecordValueProtocol.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/15/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import CoreLocation

public protocol RecordValueProtocol { }

// Refer to the Types and Dictionaries section within the reference
// https://developer.apple.com/library/archive/documentation/DataManagement/Conceptual/CloudKitWebServicesReference/Types.html

extension Data: RecordValueProtocol { }
extension Date: RecordValueProtocol { }
extension Double: RecordValueProtocol { }
extension Int64: RecordValueProtocol { }

extension CLLocation: RecordValueProtocol { }
extension LocationDictionary: RecordValueProtocol { }

extension Record.Reference: RecordValueProtocol { }
extension ReferenceDictionary: RecordValueProtocol { }

extension String: RecordValueProtocol { }

extension Array: RecordValueProtocol where Element: RecordValueProtocol { }
