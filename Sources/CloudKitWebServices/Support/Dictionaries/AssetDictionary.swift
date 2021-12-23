//
//  AssetDictionary.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/19/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

/// An asset dictionary represents an Asset field type.
struct AssetDictionary: Codable {
    
    enum CodingKeys: String, CodingKey {
        case fileChecksum
        case size
        case referenceChecksum
        case wrappingKey
        case downloadURL
    }
    
    let fileChecksum: String
    let size: Int64
    let referenceChecksum: String?
    let wrappingKey: String?
    // TODO: let receipt: UploadAssetData
    
    /// The location of the asset data to download. This key is present only when fetching the enclosing record.
    let downloadURL: URL?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.fileChecksum = try container.decode(String.self, forKey: .fileChecksum)
        self.size = try container.decode(Int64.self, forKey: .size)
        self.referenceChecksum = try container.decodeIfPresent(String.self, forKey: .referenceChecksum)
        self.wrappingKey = try container.decodeIfPresent(String.self, forKey: .wrappingKey)
        
        if let downloadURLString = try container.decodeIfPresent(String.self, forKey: .downloadURL) {
            self.downloadURL = URL(string: downloadURLString)
        } else {
            self.downloadURL = nil
        }
    }
}

// TODO: Temporary, eventually want to switch this to an internal protocol OR remove conformance entirely and replace occurrences in record's fields with public type
extension AssetDictionary: RecordValueProtocol { }
