//
//  CKAsset.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/19/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

/// An external file that belongs to a record.
public struct CKAsset {
    /// The URL for accessing the asset.
    ///
    /// After you create an asset, use the URL in this property to access the asset's contents. The URL in this property is different from the one you specified when creating the asset.
    public let fileURL: URL?
    
    /// Creates an asset that references a file.
    /// - Parameter fileURL: The URL of the file that you want to store in CloudKit. The URL must be a file URL, and must not be `nil`.
    public init(fileURL: URL?) {
        self.fileURL = fileURL
    }
}

extension CKAsset: CKRecordValueProtocol { }
