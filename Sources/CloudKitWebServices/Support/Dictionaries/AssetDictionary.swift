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
    let fileChecksum: String
    let size: String
    let referenceChecksum: String
    let wrappingKey: String
    // TODO: let receipt: UploadAssetData
    
    /// The location of the asset data to download. This key is present only when fetching the enclosing record.
    let downloadURL: URL?
}
