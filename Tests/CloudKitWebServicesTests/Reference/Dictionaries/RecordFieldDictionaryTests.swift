//
//  RecordFieldDictionaryTests.swift
//  
//
//  Created by Eric Dorphy on 1/10/22.
//

@testable import CloudKitWebServices
import CoreLocation
import XCTest

class RecordFieldDictionaryTests: XCTestCase {
    func testDecodeAssetType() throws {
        let testData =
        """
        {
            "value": {
                "fileChecksum": "ATiNtj034tTgyAwHN4aZsVKXSGyK",
                "size": 102206,
                "downloadURL": "https://cvws.icloud-content.com/B/somerecordpath"
            },
            "type": "ASSETID"
        }
        """
            .data(using: .utf8)!
        
        let value = try JSONDecoder().decode(RecordFieldDictionary.self, from: testData)
        
        XCTAssertEqual(value.type, .asset)
        
        let asset = value.value as? CKWSRemoteAsset
        XCTAssertNotNil(asset)
        XCTAssertEqual(asset?.downloadURL, URL(string: "https://cvws.icloud-content.com/B/somerecordpath")!)
    }
    
    func testDecodeDateTimeType() throws {
        
        // Jan 1, 2001 @ Midnight in milliseconds
        
        let testData =
        """
        {
            "value": 978307200000,
            "type": "TIMESTAMP"
        }
        """
            .data(using: .utf8)!
        
        let value = try JSONDecoder().decode(RecordFieldDictionary.self, from: testData)
        
        XCTAssertEqual(value.type, .dateTime)
        XCTAssertEqual(value.value as? Date, Date(timeIntervalSinceReferenceDate: 0))
    }
    
    func testDecodeDoubleType() throws {
        let testData =
        """
        {
            "value": 12345.6789,
            "type": "DOUBLE"
        }
        """
            .data(using: .utf8)!
        
        let value = try JSONDecoder().decode(RecordFieldDictionary.self, from: testData)
        
        XCTAssertEqual(value.type, .double)
        XCTAssertEqual(value.value as? Double, 12345.6789)
    }
    
    func testDecodeInt64Type() throws {
        let testData =
        """
        {
            "value": 12345,
            "type": "INT64"
        }
        """
            .data(using: .utf8)!
        
        let value = try JSONDecoder().decode(RecordFieldDictionary.self, from: testData)
        
        XCTAssertEqual(value.type, .int64)
        XCTAssertEqual(value.value as? Int64, 12345)
    }
    
    func testDecodeLocationType() throws {
        let testData =
        """
        {
            "value": {
                "latitude": 45.000,
                "longitude": -93.000,
            },
            "type": "LOCATION"
        }
        """
            .data(using: .utf8)!
        
        let value = try JSONDecoder().decode(RecordFieldDictionary.self, from: testData)
        
        XCTAssertEqual(value.type, .location)
        let location = value.value as? CLLocation
        XCTAssertNotNil(location)
        XCTAssertEqual(location?.coordinate.latitude, 45.000)
        XCTAssertEqual(location?.coordinate.longitude, -93.000)
    }
    
    func testDecodeReferenceType() throws {
        let referenceRecordID: CKWSRecord.ID = CKWSRecord.ID(recordName: UUID().uuidString)
        
        let testData =
        """
        {
            "value": {
                "recordName": "\(referenceRecordID.recordName)",
                "action": "NONE"
            },
            "type": "REFERENCE"
        }
        """
            .data(using: .utf8)!
        
        let value = try JSONDecoder().decode(RecordFieldDictionary.self, from: testData)
        
        XCTAssertEqual(value.type, .reference)
        
        let reference = value.value as? CKWSRecord.Reference
        XCTAssertNotNil(reference)
        XCTAssertEqual(reference?.recordID, referenceRecordID)
        XCTAssertEqual(reference?.action, CKWSRecord.ReferenceAction.none)
    }
    
    func testDecodeStringType() throws {
        let testData =
        """
        {
            "value": "a test string value",
            "type": "STRING"
        }
        """
            .data(using: .utf8)!
        
        let value = try JSONDecoder().decode(RecordFieldDictionary.self, from: testData)
        
        XCTAssertEqual(value.type, .string)
        XCTAssertEqual(value.value as? String, "a test string value")
    }
    
    // TODO: Add tests for list fields
}
