//
//  CKDatabase.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/12/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public class CKDatabase {
    
    // MARK: - Types
    
    public enum Scope: String {
        
        // swiftlint:disable redundant_string_enum_value
        
        case `public` = "public"
        
        // TODO: Add support for .private and .shared once user authentication is setup
        // case `private` = "private"
        // case shared = "shared"
        
        // swiftlint:enable redundant_string_enum_value
    }
    
    // MARK: - Properties
    
    internal private(set) weak var container: CKContainer?
    
    public let scope: Scope
    
    // MARK: - Initialization
    
    init(container: CKContainer, scope: Scope) {
        self.container = container
        self.scope = scope
    }
    
    public func add(_ operation: CKDatabaseOperation) {
        guard operation.isCancelled == false else {
            // TODO: Check CloudKit behavior and see which completion handlers are still invoked in this case.
            return
        }
        
        operation.database = self
        
        // TODO: Add CKOperationGroup and corresponding configuration? Check the rules for which property takes effect.
        operation.qualityOfService = operation.configuration.qualityOfService
        
        guard let container = container else {
            fatalError("database is missing container")
        }
        
        container.add(operation)
    }
}

internal extension CKDatabase {
    func getURL() -> URL {
        guard let container = container else {
            fatalError("database is missing container")
        }
        
        var url = container.getContainerURL()
        url.appendPathComponent(scope.rawValue)
        
        return url
    }
}
