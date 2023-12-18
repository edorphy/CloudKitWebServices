//
//  RecordFieldDictionary.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/19/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import CoreLocation

struct RecordFieldDictionary: Codable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case value
        case type
    }
    
    // This type isn't explicitly defined in the reference so it is internal.
    // When integrating with the web API and inspecting the raw JSON you can find these type strings

    // TODO: Like this name? It is internal but feels like it is a main type. Consider making it more verbose

    enum FieldType: String, Codable {
        case asset      = "ASSETID"
        // TODO: case byte = "BYTE"
        case dateTime   = "TIMESTAMP"
        case double     = "DOUBLE"
        case int64      = "INT64"
        case location   = "LOCATION"
        case reference  = "REFERENCE"
        case string     = "STRING"
        
        case assetList      = "ASSETID_LIST"
        // TODO: case byteList = "BYTE_LIST"
        case dateTimeList   = "TIMESTAMP_LIST"
        case doubleList     = "DOUBLE_LIST"
        case int64List      = "INT64_LIST"
        case locationList   = "LOCATION_LIST"
        case referenceList  = "REFERENCE_LIST"
        case stringList     = "STRING_LIST"
        
        // Observed undocumented / unexpected type string 'UNKNOWN_LIST'
        // Submitted feedback: FB9825479
        // TODO: case unknownList = "UNKNOWN_LIST"
    }
    
    
    let value: CKRecordValueProtocol
    
    // TODO: The reference states that type is optional, but what is the practical usage of this? Maybe make it required
    let type: FieldType?
    
    init(value: CKRecordValueProtocol, type: FieldType?) {
        self.value = value
        self.type = type
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        
        // TODO: Use the new type safe FieldType or guard type + data are same type?
        
        switch value {
            
        case let dataValue as Data:
            let base64Encodedvalue = dataValue.base64EncodedString()
            try container.encode(base64Encodedvalue, forKey: .value)
            
        case let dateValue as Date:
            // Represented as a number in milliseconds between midnight on January 1, 1970, and the specified date or time.
            let epochValue = dateValue.timeIntervalSince1970 * 1000
            try container.encode(epochValue, forKey: .value)
            
        case let doubleValue as Double:
            try container.encode(doubleValue, forKey: .value)
            
        case let intValue as Int64:
            try container.encode(intValue, forKey: .value)
            
        case let locationValue as CLLocation:
            let locationDictionary = LocationDictionary(from: locationValue)
            try container.encode(locationDictionary, forKey: .value)
            
        case let locationValue as LocationDictionary:
            try container.encode(locationValue, forKey: .value)
            
        case let referenceValue as ReferenceDictionary:
            try container.encode(referenceValue, forKey: .value)
            
        case let recordReferenceValue as CKRecord.Reference:
            try container.encode(ReferenceDictionary(reference: recordReferenceValue), forKey: .value)
            
        case let stringValue as String:
            try container.encode(stringValue, forKey: .value)
            
        // TODO: Add support for array encoding
            
        default:
            fatalError("RecordFieldDictionary encode not implemented for type \(String(describing: type))")
        }
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let type = try values.decodeIfPresent(FieldType.self, forKey: .type) else {
            let rawType = (try? values.decodeIfPresent(String.self, forKey: .type)) ?? "unknown type"
            assertionFailure("Unexpected record field type: \(rawType), file an issue on GitHub with sample json/data and the record type from Console.")
            self.type = .string
            self.value = ""
            return
        }
        
        self.type = type
        
        switch type {
            
        case .asset:
            let assetDictionary = try values.decode(AssetDictionary.self, forKey: .value)
            // TODO: Figure out a way to detect if asset is remote or local, but for now since the library is read-only, it HAS to be remote
            self.value = CKRemoteAsset(assetDictionary: assetDictionary)
            
        // TODO: Bytes
            
        case .dateTime:
            // Documenation states an integer in milliseconds since 1970
            let timeInterval = try values.decode(Int64.self, forKey: .value)
            self.value = Date(timeIntervalSince1970: Double(timeInterval / 1000))
        
        case .double:
            let doubleValue = try values.decode(Double.self, forKey: .value)
            self.value = doubleValue
            
        case .int64:
            let intValue = try values.decode(Int64.self, forKey: .value)
            self.value = intValue
            
        case .location:
            let locationDictionary = try values.decode(LocationDictionary.self, forKey: .value)
            self.value = CLLocation(locationDictionary: locationDictionary)
            
        case .reference:
            let reference = try values.decode(ReferenceDictionary.self, forKey: .value)
            self.value = CKRecord.Reference(reference: reference)
        
        case .string:
            let stringValue = try values.decode(String.self, forKey: .value)
            self.value = stringValue
            
        // MARK: - List Support
        
        case .assetList:
            let assetDictionaries = try values.decode([AssetDictionary].self, forKey: .value)
            // TODO: Figure out a way to detect if asset is remote or local, but for now since the library is read-only, it HAS to be remote
            self.value = assetDictionaries.map { CKRemoteAsset(assetDictionary: $0) }
            
        // TODO: Bytes List
            
        case .dateTimeList:
            // Documenation states an integer in milliseconds since 1970
            let timeIntervals = try values.decode([Int64].self, forKey: .value)
            self.value = timeIntervals.map { Date(timeIntervalSince1970: Double($0 / 1000)) }
            
        case .doubleList:
            let doubleValues = try values.decode([Double].self, forKey: .value)
            self.value = doubleValues
            
        case .int64List:
            self.value = try values.decode([Int64].self, forKey: .value)
            
        case .locationList:
            let locationDictionaries = try values.decode([LocationDictionary].self, forKey: .value)
            self.value = locationDictionaries.map { CLLocation(locationDictionary: $0) }
            
        case .referenceList:
            let references = try values.decode([ReferenceDictionary].self, forKey: .value)
            self.value = references.map { CKRecord.Reference(reference: $0) }
            
        case .stringList:
            let stringValues = try values.decode([String].self, forKey: .value)
            self.value = stringValues
        }
    }
}
