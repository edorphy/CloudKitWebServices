//
//  CKRecordValueProtocol.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/15/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import CoreLocation

public protocol CKRecordValueProtocol { }

// Refer to the Types and Dictionaries section within the reference
// https://developer.apple.com/library/archive/documentation/DataManagement/Conceptual/CloudKitWebServicesReference/Types.html

extension Data: CKRecordValueProtocol { }
extension Date: CKRecordValueProtocol { }
extension Double: CKRecordValueProtocol { }
extension Int64: CKRecordValueProtocol { }

extension CLLocation: CKRecordValueProtocol { }
extension LocationDictionary: CKRecordValueProtocol { }

extension CKRecord.Reference: CKRecordValueProtocol { }
extension ReferenceDictionary: CKRecordValueProtocol { }

extension String: CKRecordValueProtocol { }

extension Array: CKRecordValueProtocol where Element: CKRecordValueProtocol { }
