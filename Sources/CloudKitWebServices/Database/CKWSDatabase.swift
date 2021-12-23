//
//  CKWSDatabase.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/12/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public class CKWSDatabase {
    
    internal private(set) weak var container: CKWSContainer?
    
    public let scope: Scope
    
    private let operationQueue: OperationQueue = OperationQueue()
    
    init(container: CKWSContainer, scope: Scope) {
        self.container = container
        self.scope = scope
    }
    
    public func add(_ operation: DatabaseOperation) {
        guard operation.isCancelled == false else { return }
        
        operation.database = self
        
        self.operationQueue.addOperation(operation)
    }
}

internal extension CKWSDatabase {
    func getURL() -> URL {
        guard let container = container else {
            fatalError("database is missing container")
        }
        
        var url = container.getContainerURL()
        url.appendPathComponent(scope.rawValue)
        
        return url
    }
}

public extension CKWSDatabase {
    enum Scope: String {
        
        // swiftlint:disable redundant_string_enum_value
        
        case `public` = "public"
        
        // TODO: Add support for .private and .shared once user authentication is setup
        // case `private` = "private"
        // case shared = "shared"
        
        // swiftlint:enable redundant_string_enum_value
    }
}
