//
//  FetchRecordsOperation.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/12/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public class FetchRecordsOperation: DatabaseOperation {
    
    // MARK: - Properties
    
    private let recordIDs: [Record.ID]
    
    public var desiredKeys: [Record.FieldKey]?
    
    public var perRecordResultBlock: ((Record.ID, Result<Record, Error>) -> Void)?
    
    public var fetchRecordsResultBlock: ((Result<Void, Error>) -> Void)?
    
    // MARK: - Initialization
    
    public init(recordIDs: [Record.ID]) {
        self.recordIDs = recordIDs
    }
    
    override public func main() {
        
        let request: URLRequest
        
        do {
            request = try createRequest()
        } catch {
            fetchRecordsResultBlock?(.failure(error))
            self.finish()
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                self.finish()
            }
            
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                self.invokeCompletionBlock(error!)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                // TODO: If we can trust the new async/await method signature and documentation, if no error we should ALWAYS have data and response. Use internal error?
                self.invokeCompletionBlock(NSError())
                assertionFailure("Unexpected case. Debug this.")
                return
            }
            
            do {
                switch response.statusCode {
                case 200:
                    
                    let body = try JSONDecoder().decode(ResponseBody.self, from: data)
                    
                    var records: [Record.ID: Record] = [:]
                    var failureRecords: [Record.ID: RecordFetchErrorDictionary] = [:]
                    
                    body.records.forEach { recordResult in
                        
                        switch recordResult {
                        case .success(let recordDictionary):
                            let record = Record(recordDictionary: recordDictionary)
                            records[record.recordID] = record
                            self.invokeRecordResultBlock((record.recordID, .success(record)))
                            
                        case .failure(let errorDictionary):
                            // swiftlint:disable:next force_unwrapping
                            let recordID = Record.ID(recordName: errorDictionary.recordName!)
                            failureRecords[recordID] = errorDictionary
                            self.invokeRecordResultBlock((recordID, .failure(errorDictionary)))
                        }
                    }
                    
                    self.invokeCompletionBlock(PartialFailure(failedRecords: failureRecords))
                    
                case 503:
                    // TODO: Convert to ServiceUnavailable code, decode body for a an after key to put into error's userInfo
                    fatalError("convert to named error, this will be hard to test what Apple's real body returns")
                    
                default:
                    let errorResponse = try JSONDecoder().decode(RecordFetchErrorDictionary.self, from: data)
                    self.invokeCompletionBlock(errorResponse)
                }
            } catch {
                // TODO: Catch per status code and use a helper function
                fatalError("Received an error decoding the fetch response: \(error)")
            }
        }
        
        task.resume()
    }
    
    private func invokeRecordResultBlock(_ completion: @autoclosure () -> (recordID: Record.ID, result: Result<Record, Error>)) {
        if let perRecordResultBlock = self.perRecordResultBlock {
            let result = completion()
            perRecordResultBlock(result.recordID, result.result)
        }
    }
    
    private func invokeCompletionBlock(_ completion: @autoclosure () -> (Error?)) {
        if let fetchRecordsResultBlock = self.fetchRecordsResultBlock {
            if let error = completion() {
                fetchRecordsResultBlock(.failure(error))
            } else {
                fetchRecordsResultBlock(.success(()))
            }
        }
    }
    
    private func createRequest() throws -> URLRequest {
        var request = URLRequest(url: getURL())
        request.httpMethod = "POST"
        
        let requestBody = RequestBody(
            records: recordIDs.map({ recordID in
                LookupRecordDictionary(recordName: recordID.recordName)
            }), desiredKeys: self.desiredKeys
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            // TODO: Convert this to throws invalidArguments error
            throw error
        }
        
        request.allowsCellularAccess = configuration.allowsCellularAccess
        request.timeoutInterval = configuration.timeoutIntervalForRequest
        
        return request
    }
}

extension FetchRecordsOperation {
    func getURL() -> URL {
        guard let database = self.database else {
            fatalError("the operation was not configured with a database which is required")
        }
        
        var url = getRecordsURL(database: database)
        url.appendPathComponent("lookup")
        
        return url
    }
}
