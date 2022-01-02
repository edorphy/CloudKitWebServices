//
//  CKWSContainer-Configuration.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 1/2/22.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public extension CKWSContainer {
    struct Configuration {
        public let containerIdentifier: ContainerIdentifier
        public let apiToken: APIToken
        public let environment: Environment
        public let session: URLSession
        
        public init(identifier: ContainerIdentifier, token: APIToken, environment: Environment = .production, session: URLSession = .shared) {
            
            // TODO: Make this initializer throw if invalid or create a validate method?
            
            self.containerIdentifier = identifier
            self.apiToken = token
            self.environment = environment
            self.session = session
        }
    }
    
    // TODO: Make this the required initializer?
    convenience init(configuration: Configuration) {
        self.init(
            identifier: configuration.containerIdentifier,
            token: configuration.apiToken,
            environment: configuration.environment,
            session: configuration.session
        )
    }
}
