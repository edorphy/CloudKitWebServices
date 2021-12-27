//
//  RecordFieldDictionary.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/19/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import CoreLocation

struct RecordFieldDictionary: Codable {
    
    enum CodingKeys: String, CodingKey {
        case value
        case type
    }
    
    let value: CKWSRecordValueProtocol
    
    // TODO: The reference states that type is optional, but what is the practical usage of this? Maybe make it required
    let type: String?
    
    init(value: CKWSRecordValueProtocol, type: String?) {
        self.value = value
        self.type = type
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        
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
            
        case let recordReferenceValue as CKWSRecord.Reference:
            try container.encode(ReferenceDictionary(reference: recordReferenceValue), forKey: .value)
            
        case let stringValue as String:
            try container.encode(stringValue, forKey: .value)
            
        // TODO: Add support for array encoding
            
        default:
            fatalError("RecordFieldDictionary encode not implemented for type \(type ?? "unspecified-type")")
        }
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let type = try values.decodeIfPresent(String.self, forKey: .type) else {
            // TODO: Not sure what to do here, it isn't documented
            fatalError("figure out graceful decoding, maybe throw required key missing?")
        }
        
        self.type = type
        
        switch type {
            
        case "ASSETID":
            let assetDictionary = try values.decode(AssetDictionary.self, forKey: .value)
            // TODO: Figure out a way to detect if asset is remote or local, but for now since the library is read-only, it HAS to be remote
            self.value = CKWSRemoteAsset(assetDictionary: assetDictionary)
            
        // TODO: Bytes
            
        case "TIMESTAMP":
            // Documenation states an integer in milliseconds since 1970
            let timeInterval = try values.decode(Int64.self, forKey: .value)
            self.value = Date(timeIntervalSince1970: Double(timeInterval / 1000))
        
        case "DOUBLE":
            let doubleValue = try values.decode(Double.self, forKey: .value)
            self.value = doubleValue
            
        case "INT64":
            let intValue = try values.decode(Int64.self, forKey: .value)
            self.value = intValue
            
        case "LOCATION":
            let locationDictionary = try values.decode(LocationDictionary.self, forKey: .value)
            self.value = CLLocation(locationDictionary: locationDictionary)
            
        case "REFERENCE":
            let reference = try values.decode(ReferenceDictionary.self, forKey: .value)
            self.value = CKWSRecord.Reference(reference: reference)
        
        case "STRING":
            let stringValue = try values.decode(String.self, forKey: .value)
            self.value = stringValue
            
        // MARK: - List Support
        
        case "ASSETID_LIST":
            let assetDictionaries = try values.decode([AssetDictionary].self, forKey: .value)
            // TODO: Figure out a way to detect if asset is remote or local, but for now since the library is read-only, it HAS to be remote
            self.value = assetDictionaries.map { CKWSRemoteAsset(assetDictionary: $0) }
            
        // TODO: Bytes List
            
        case "TIMESTAMP_LIST":
            // Documenation states an integer in milliseconds since 1970
            let timeIntervals = try values.decode([Int64].self, forKey: .value)
            self.value = timeIntervals.map { Date(timeIntervalSince1970: Double($0 / 1000)) }
            
        case "DOUBLE_LIST":
            let doubleValues = try values.decode([Double].self, forKey: .value)
            self.value = doubleValues
            
        case "INT64_LIST":
            self.value = try values.decode([Int64].self, forKey: .value)
            
        case "LOCATION_LIST":
            let locationDictionaries = try values.decode([LocationDictionary].self, forKey: .value)
            self.value = locationDictionaries.map { CLLocation(locationDictionary: $0) }
            
        case "REFERENCE_LIST":
            let references = try values.decode([ReferenceDictionary].self, forKey: .value)
            self.value = references.map { CKWSRecord.Reference(reference: $0) }
            
        case "STRING_LIST":
            let stringValues = try values.decode([String].self, forKey: .value)
            self.value = stringValues
            
        default:
            print("Unhandeled type: \(type)")
            fatalError("if you run into this, open up a PR with a new decoding strategy for the unhandled type")
        }
    }
}
