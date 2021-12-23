//
//  CKWSContainer.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/12/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public class CKWSContainer {
    
    public let containerIdentifier: String
    
    public private(set) lazy var publicCloudDatabase: CKWSDatabase = {
        CKWSDatabase(container: self, scope: .public)
    }()
    
    internal let apiToken: String
    
    private let session: URLSession = .shared
    
    private let environment: Environment
    
    public init(identifier: String, token: String) {
        self.containerIdentifier = identifier
        self.apiToken = token
        
        #if DEBUG
        self.environment = .development
        #else
        self.environment = .production
        #endif
    }
}

internal extension CKWSContainer {
    
    func getContainerURL() -> URL {
        .pathURL
            .appendingPathComponent("database")
            .appendingPathComponent(APIVersion.version1.rawValue)
            .appendingPathComponent(containerIdentifier)
            .appendingPathComponent(environment.rawValue)
    }
}

private extension URL {
    // swiftlint:disable:next force_unwrapping
    static let pathURL: URL = URL(string: "https://api.apple-cloudkit.com")!
}

extension CKWSContainer {
    
    private enum APIVersion: String {
        case version1 = "1"
    }
    
    private enum Environment: String {
        case development
        case production
    }
}
