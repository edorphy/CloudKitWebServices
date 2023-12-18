//
//  CKContainer.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/12/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public class CKContainer {
    
    // MARK: - Types
    
    public typealias ContainerIdentifier = String
    
    public typealias APIToken = String
    
    public enum Environment: String {
        case development
        case production
    }
    
    // MARK: - Properties
    
    public let containerIdentifier: ContainerIdentifier
    
    public let environment: Environment
    
    public private(set) lazy var publicCloudDatabase: CKDatabase = {
        CKDatabase(container: self, scope: .public)
    }()
    
    internal let apiToken: APIToken
    
    internal let session: URLSession
    
    private let operationQueue: OperationQueue = OperationQueue()
    
    // MARK: - Initialization
    
    public init(identifier: ContainerIdentifier, token: APIToken, environment: Environment = .production, session: URLSession = .shared) {
        
        // TODO: Ensure that the identifier begins with "iCloud." to help developers out.
        
        self.containerIdentifier = identifier
        self.apiToken = token
        self.environment = environment
        self.session = session
    }
    
    // TODO: A second initializer that takes a configuration? Take a play out of the CloudKit JS lib API?
    
    // MARK: - Public Functions
    
    public func database(with scope: CKDatabase.Scope) -> CKDatabase {
        switch scope {
        case .public:
            return self.publicCloudDatabase
        }
    }
    
    public func add(_ operation: CKOperation) {
        
        // TODO: Inspect the configuration and apply them to the operation before enqueuing.
        self.operationQueue.addOperation(operation)
    }
}

extension CKContainer {
    
    func getContainerURL() -> URL {
        
        // According to the docmentation the Web Service URL should always match the following pattern:
        // [path]/database/[version]/[container]/[environment]/[operation-specific subpath]
        
        let version = "1"
        
        return URL.pathURL
            .appendingPathComponent("database/\(version)/\(containerIdentifier)/\(environment.rawValue)")
    }
}

private extension URL {
    // swiftlint:disable:next force_unwrapping
    static let pathURL: URL = URL(string: "https://api.apple-cloudkit.com")!
}
