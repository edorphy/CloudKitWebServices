//
//  CKWSCloudOperation.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/12/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public class CKWSCloudOperation: Operation {
    
    // TODO: Add a better label to this queue that perhaps uses the bundle and the prefix of a UUID to randomize each operation
    private let lockQueue = DispatchQueue(label: "dev.twincitiesapp.cloudkitwebservices.cloudoperation", attributes: .concurrent)
    
    override public var isAsynchronous: Bool {
        true
    }
    
    private var _isExecuting: Bool = false
    override public var isExecuting: Bool {
        get {
            
            lockQueue.sync {
                _isExecuting
            }
        }
        
        set {
            willChangeValue(forKey: "isExecuting")
            lockQueue.sync {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _isFinished: Bool = false
    override public private(set) var isFinished: Bool {
        get {
            lockQueue.sync { () -> Bool in
                _isFinished
            }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override public func start() {
        
        guard isCancelled == false else {
            finish()
            return
        }
        
        isFinished = false
        isExecuting = true
        main()
    }
    
    func finish() {
        isExecuting = false
        isFinished = true
    }
}
