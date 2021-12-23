//
//  RecordValueProtocol.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/15/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import CoreLocation

public protocol RecordValueProtocol { }

extension Date: RecordValueProtocol { }
extension Double: RecordValueProtocol { }
extension Int64: RecordValueProtocol { }

extension Record.Reference: RecordValueProtocol { }

extension String: RecordValueProtocol { }
extension CLLocation: RecordValueProtocol { }

extension Array: RecordValueProtocol where Element: RecordValueProtocol { }

// MARK: - Internal Types

// TODO: Consider making a RecordValueProtocolInternal that inherits from RecordValue protocol

extension LocationDictionary: RecordValueProtocol { }
extension ReferenceDictionary: RecordValueProtocol { }
