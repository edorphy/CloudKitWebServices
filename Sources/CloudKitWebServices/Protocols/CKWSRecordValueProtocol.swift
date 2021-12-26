//
//  CKWSRecordValueProtocol.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/15/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import CoreLocation

public protocol CKWSRecordValueProtocol { }

// Refer to the Types and Dictionaries section within the reference
// https://developer.apple.com/library/archive/documentation/DataManagement/Conceptual/CloudKitWebServicesReference/Types.html

extension Data: CKWSRecordValueProtocol { }
extension Date: CKWSRecordValueProtocol { }
extension Double: CKWSRecordValueProtocol { }
extension Int64: CKWSRecordValueProtocol { }

extension CLLocation: CKWSRecordValueProtocol { }
extension LocationDictionary: CKWSRecordValueProtocol { }

extension CKWSRecord.Reference: CKWSRecordValueProtocol { }
extension ReferenceDictionary: CKWSRecordValueProtocol { }

extension String: CKWSRecordValueProtocol { }

extension Array: CKWSRecordValueProtocol where Element: CKWSRecordValueProtocol { }
