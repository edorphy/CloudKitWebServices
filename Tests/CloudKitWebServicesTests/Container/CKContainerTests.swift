//
//  CKContainerTests.swift
//  CloudKitWebServicesTests
//
//  Created by Eric Dorphy on 12/22/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import CloudKitWebServices
import XCTest

class CKContainerTests: XCTestCase {

    func testContainerInit() throws {
        XCTAssertNotNil(CKContainer(identifier: "non-empty-value", token: "non-empty-value"))
    }
    
    func testContainer_EmptyIdentifier_Fails() throws {
        throw XCTSkip("Code needs updating to fail initialization")
        
        // let container = CKContainer(identifier: "", token: "non-empty-value")
    }
    
    func testContainer_EmptyAPIToken_Fails() throws {
        throw XCTSkip("Code needs updating to fail initialization")
        
        // let container = CKContainer(identifier: "non-empty-value", token: "")
    }
}
