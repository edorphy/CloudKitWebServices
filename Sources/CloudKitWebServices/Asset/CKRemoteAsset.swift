//
//  CKRemoteAsset.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 12/26/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public struct CKRemoteAsset: CKAssetProtocol {
    public let downloadURL: URL
    
    init(assetDictionary: AssetDictionary) {
        guard let downloadURL = assetDictionary.downloadURL else {
            fatalError("Constructing a remote asset without a downloadURL - huh?")
        }
        
        self.downloadURL = downloadURL
    }
}

extension CKRemoteAsset: CKRecordValueProtocol { }
